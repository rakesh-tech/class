require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
  	response = DeskDb.new('facebook_users',project)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
   last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
    path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('facebook_users',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
     file_path = File.new("#{Rails.root}/tmp/#{project.name}_facebook_user_#{page}.csv", "w")

    company_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["Image URL","Profile Url", "Created_at", "Updated_at", "Customer ID", "Facebook User ID"]
      # data row
      converted_response.each do |facebook_data|

      unless facebook_data["_links"]["customer"].nil?
         customer_id = facebook_data["_links"]["customer"]["href"].split('/').last
      end
      unless facebook_data["_links"]["self"].nil?
        facebook_user_id = facebook_data["_links"]["self"]["href"].split('/').last
      end

		csv << [facebook_data["image_url"], facebook_data["profile_url"], facebook_data[" created_at"], facebook_data["updated_at"],customer_id, facebook_user_id]
	   end
     path_array << file_path.path
     end
   end
     p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_facebook => path, :facebook_user_download_at => Time.now)
    else
     project.create_project_file(:csv_facebook => path, :facebook_user_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Facebook User csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end
