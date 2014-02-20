require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
  	response = DeskDb.new('companies',project)
    last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
    path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('companies',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
     file_path = File.new("#{Rails.root}/tmp/#{project.name}_company_#{page}.csv", "w")

    company_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["Name","Domains", "Created_at", "Updated_at", "Customers ID", "Cases ID"] + converted_response.first["custom_fields"].keys
      # data row
      converted_response.each do |company_data|
        domains = ""

      unless company_data["_links"]["customers"].nil?
        response_customer = DeskDb.new(company_data["_links"]["customers"]["href"],project) 
        response=JSON.parse(response_customer.get_link_data._embedded.to_json)["entries"]
        customer_id_array =[]
        response.each{|res| customer_id_array << res["_links"]["self"]["href"].split('/').last }
        customer_id = customer_id_array.join('|')
      end
      unless company_data["_links"]["cases"].nil?
        response_case = DeskDb.new(company_data["_links"]["cases"]["href"],project) 
        response=JSON.parse(response_case.get_link_data._embedded.to_json)["entries"]
         case_id_array =[]
        response.each{|res| case_id_array << res["_links"]["self"]["href"].split('/').last }
        case_id = case_id_array.join('|')
      end
      domain_array = []
        company_data["domains"].each{|data| domain_array << data}
        domains = domain_array.join('|')
		csv << [company_data["name"], domains, company_data[" created_at"], company_data["updated_at"],customer_id, case_id] + company_data["custom_fields"].values
	   end
       path_array << file_path.path
     end
   end
    p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_company => path,:company_download_at => Time.now)
    else
     project.create_project_file(:csv_company=>path,:company_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Company csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end