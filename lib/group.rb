require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
  	response = DeskDb.new('groups',project)
    last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
    path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('groups',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    file_path = File.new("#{Rails.root}/tmp/#{project.name}_group_#{page}.csv", "w")
    group_csv = CSV.open(file_path, "w") do |csv|
        # header row
      csv << ["Name","Group ID","Users ID"]
      user_id = ""
      # data row
      converted_response.each do | group |
       unless group["_links"]["users"].nil?
          response_user = DeskDb.new(group["_links"]["users"]["href"],project) 
          response=JSON.parse(response_user.get_link_data._embedded.to_json)["entries"]
          user_id_array = []
          response.each{|res| user_id_array << res["_links"]["self"]["href"].split('/').last}
          user_id = user_id_array.join('|')
        end
          group_id = group["_links"]["self"]["href"].split('/').last
          csv << [group["name"],group_id, user_id]
        end
        path_array << file_path.path
      end
    end
    p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_group => path, :group_download_at => Time.now)
    else
     project.create_project_file(:csv_group => path, :group_download_at => Time.now)
    end
    p path
	  p "Sucessfully generated Group csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end