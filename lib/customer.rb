require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
	response = DeskDb.new('customers',project)
  last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
  path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('customers',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
	  file_path = File.new("#{Rails.root}/tmp/#{project.name}_customer_#{page}.csv", "w")
    customer_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["Customer ID", "Company ID","First Name", "Last Name", "Company", "Title", "External Id", "Background", "Language","Email", "Phone Numbers", "Addresses","Created_at", "Updated_at", "Locked_until","Facebook User ID", "Twitter User ID","Facebook Href", "Twitter Href", "Cases ID", "Locked By"] + converted_response.first["custom_fields"].keys
      # data row
      converted_response.each do |customer|
        data = ""
        phone = ""
        address = ""
        case_id = ""
        company_id = ""
        facebook_user_id = ""
        twitter_user_id = ""
        facebook_href = ""
        twitter_href = ""

       unless customer.nil? && customer["_links"]["cases"].nil?
         response_message = DeskDb.new(customer["_links"]["cases"]["href"],project) 
         response = JSON.parse(response_message.get_link_data._embedded.to_json)["entries"]
         case_id_array = []
         response.each{|res| case_id_array << res["_links"]["self"]["href"].split('/').last}
         case_id = case_id_array.join('|')
        end
        if customer["_links"]["facebook_user"].present?
          facebook_href = customer["_links"]["facebook_user"]["href"]
          facebook_user_id = customer["_links"]["facebook_user"]["href"].split('/').last 
        end
        if customer["_links"]["twitter_user"].present?
          twitter_href = customer["_links"]["twitter_user"]["href"]
          twitter_user_id = customer["_links"]["twitter_user"]["href"].split('/').last 
        end
        if customer["_links"]["company"].present?
         company_id = customer["_links"]["company"]["href"].split('/').last
        end
        email_array = []
        customer["emails"].each{|email| email_array <<  email["value"]  }
        data = email_array.join('|')
        seperator_phone = ',' if customer["phone_numbers"].count > 1
        phone_array = []
        customer["phone_numbers"].each{|phone_number| phone_array << phone_number["value"]} 
        phone = phone_array.join('|')
        customer["addresses"].each{|addres| address = address + addres["value"]}
        csv << [customer["id"], company_id, customer["first_name"], customer["last_name"], customer["company"], customer["title"], customer["external_id"], customer["background"], customer["language"],data, phone, address, customer["created_at"], customer["updated_at"], customer["locked_until"], facebook_user_id, twitter_user_id,facebook_href,twitter_href, case_id,customer["_links"]["locked_by"] ] + customer["custom_fields"].values
      end
      path_array << file_path.path
    end
  end
    p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_customer => path, :customer_download_at => Time.now)
    else
     project.create_project_file(:csv_customer=>path, :customer_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Customer csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end
