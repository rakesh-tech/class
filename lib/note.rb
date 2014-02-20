require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
  	response = DeskDb.new('cases',project)
    last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
    path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('cases',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    file_path = File.new("#{Rails.root}/tmp/#{project.name}_note_#{page}.csv", "w")

    note_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["Note_id","Note_Body", "Note_created_at", "Note_updated_at", "Case ID", "User ID", "Spam", "Deleted", "Erased_at"]
      # data row
      converted_response.each do |case_data|
      #Get notes
      unless case_data["_links"]["notes"].nil?
        response_note = DeskDb.new(case_data["_links"]["notes"]["href"],project)
        note = response_note.get_link_data
        response_self_note = DeskDb.new(note["_links"]["self"]["href"], project)
        note_response=JSON.parse(response_self_note.get_link_data._embedded.to_json)["entries"]
        unless note_response.empty?
        	note_response.each do |note|
		        note_id=note["_links"]["self"]["href"].split('/').last
		        note_created_at = note["created_at"]
		        note_updated_at = note["updated_at"]
            note_erased_at = note["updated_at"]
		        note_body = note["body"]
            user_id = note["_links"]["user"]["href"].split('/').last
            case_id = case_data["_links"]["self"]["href"].split('/').last
		      csv << [note_id, note_body, note_created_at, note_updated_at, case_id,user_id,'False','False', note_erased_at]
	        end
        end
      end
      end
      path_array << file_path.path
    end
  end
     p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_note => path, :note_download_at => Time.now)
    else
     project.create_project_file(:csv_note => path, :note_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Note csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end