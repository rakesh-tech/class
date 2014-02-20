require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
  	response = DeskDb.new('users',project)
    last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
    path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('users',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    file_path = File.new("#{Rails.root}/tmp/#{project.name}_user_#{page}.csv", "w")
    user_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["User Id","Name", "Public Name", "Email", "Level","Created_at", "Updated_at", "Current_login_at","Last_login_at","Href"]
      # data row
      converted_response.each do |user|
        unless user.nil?
         user_id = user["_links"]["self"]["href"].split('/').last
        end
        csv << [user_id,user["name"],user["public_name"],user["email"],user["level"], user["created_at"], user["updated_at"], user["current_login_at"], user["last_login_at"], user["_links"]["self"]["href"]]
      end
       path_array << file_path.path
    end
  end
    p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_user => path, :user_download_at => Time.now)
    else
     project.create_project_file(:csv_user=>path, :user_download_at => Time.now)
    end
    p path
	p "Sucessfully generated User csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end
