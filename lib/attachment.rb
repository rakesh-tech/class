require_relative "../config/environment.rb"
require_dependency 'lib/sources/desk.rb'
require 'csv'
require 'open-uri'

project_id = ARGV[0]
project = Project.find project_id
unless project.nil?
  begin
  	response = DeskDb.new('cases',project)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
     last_page = JSON.parse(response.get_data._links.last.to_json)["href"].split('&per_page=').first.split('=').last.to_i
    path_array = []
  (1..last_page).each do |page|
    response = DeskDb.new('cases',project, page)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
     file_path = File.new("#{Rails.root}/tmp/#{project.name}_attachment_#{page}.csv", "w")

    attachment_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["Attachment_Id","File_name", "Content Type", "Size", "Url","Created_at", "Updated_at", "Case ID","Reply ID","Message ID", "Spam", "Deleted","Erased_at"]
      # data row
      converted_response.each do |case_data|
      #Get attachments
      unless case_data["_links"]["attachments"].nil?
        response_attachment = DeskDb.new(case_data["_links"]["attachments"]["href"],project)
        attachment = response_attachment.get_link_data
        response_self_attachment = DeskDb.new(attachment["_links"]["self"]["href"], project)
        attachment_response=JSON.parse(response_self_attachment.get_link_data._embedded.to_json)["entries"]
        unless attachment_response.empty?
        	attachment_response.each do |attachment|
		        attachment_id = attachment["_links"]["self"]["href"].split('/').last
            reply_id = attachment["_links"]["reply"]["href"].split('/').last if attachment["_links"]["reply"].present?
            message_id = attachment["_links"]["message"]["href"].split('/').last if attachment["_links"]["message"].present?
		        attachment_created_at = attachment["created_at"]
		        attachment_updated_at = attachment["updated_at"]
		        attachment_file_name = attachment["file_name"]
            case_id = case_data["_links"]["self"]["href"].split('/').last
		        csv << [attachment_id, attachment_file_name,attachment["content_type"], attachment["size"], attachment["url"], attachment_created_at, attachment_updated_at, case_id,reply_id,message_id,'False','False', attachment["erased_at"]]
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
     p_file.update_attributes(:csv_attachment => path, :attachment_download_at => Time.now)
    else
     project.create_project_file(:csv_attachment=> path, :attachment_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Attachment csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end