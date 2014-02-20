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
    file_path = File.new("#{Rails.root}/tmp/#{project.name}_reply_#{page}.csv", "w")

    reply_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["Reply_Id","Reply_Body", "Reply_Created_at", "Reply_Updated_at", "Case ID", "Customer ID", "Spam", "Deleted", "Subject", "Direction", "Status", "To", "From", "CC", "BCC"]
      # data row
      converted_response.each do |case_data|
      #Get notes
      unless case_data["_links"]["replies"].nil?
        response_reply = DeskDb.new(case_data["_links"]["replies"]["href"],project)
        reply = response_reply.get_link_data
        response_self_reply = DeskDb.new(reply["_links"]["self"]["href"], project)
        reply_response=JSON.parse(response_self_reply.get_link_data._embedded.to_json)["entries"]
        unless reply_response.empty?
        	reply_response.each do |reply|
		        reply_id = reply["_links"]["self"]["href"].split('/').last
            customer_id = reply["_links"]["customer"]["href"].split('/').last
		        reply_created_at = reply["created_at"]
		        reply_updated_at = reply["updated_at"]
		        reply_body = reply["body"]
            case_id = case_data["_links"]["self"]["href"].split('/').last
		        csv << [reply_id, reply_body, reply_created_at, reply_updated_at,case_id,customer_id, 'False','False', reply["subject"], reply["direction"], reply["status"], reply["to"], reply["from"], reply["cc"], reply["bcc"]]
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
     p_file.update_attributes(:csv_reply => path, :reply_download_at => Time.now)
    else
     project.create_project_file(:csv_reply=>path, :reply_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Reply csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end
