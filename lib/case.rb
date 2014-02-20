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
    file_path = File.new("#{Rails.root}/tmp/#{project.name}_case_#{page}.csv", "w")
    case_csv = CSV.open(file_path, "w") do |csv|
      # header row
      csv << ["ID","External Id", "Blurb", "Subject", "Priority_field", "Locked until", "Description", "Status", "Source_field", "Ticket_created_at","Ticket_updated_at","Active_at", "Received_at", "Opened_at", "Message", "Group_id", "Responder_id", "Ticket_creator", "Resolved_at", "First_resolved_at", "First_opened_at"] + converted_response.first["custom_fields"].keys
      # data row
      converted_response.each do |case_data|
      # Get message of case
      unless case_data["_links"]["message"].nil?
        response_message = DeskDb.new(case_data["_links"]["message"]["href"],project) 
        message_body = response_message.get_link_data["body"]
      end
      #Get assigned grup ID
      unless case_data["_links"]["assigned_group"].nil?
        response_group = DeskDb.new(case_data["_links"]["assigned_group"]["href"],project) 
        group_id = response_group.get_link_data["_links"]["self"]["href"].split('/').last
      end
      #Get assigned user ID
      unless case_data["_links"]["assigned_user"].nil?
        response_user = DeskDb.new(case_data["_links"]["assigned_user"]["href"],project)
        user_id = response_user.get_link_data["_links"]["self"]["href"].split('/').last
      end
      
       #Get customer submitted case
      unless case_data["_links"]["customer"].nil?
        response_customer = DeskDb.new(case_data["_links"]["customer"]["href"],project)
        customer_id = response_customer.get_link_data["_links"]["self"]["href"].split('/').last
      end

        csv << [case_data["id"], case_data["external_id"],case_data["blurb"],case_data["subject"],case_data["priority"],case_data["locked_until"],case_data["description"],case_data["status"],case_data["type"], case_data["created_at"], case_data["updated_at"], case_data["active_at"], case_data["received_at"], case_data["opened_at"], message_body, group_id, user_id, customer_id, case_data["resolved_at"], case_data["first_resolved_at"], case_data["first_opened_at"]] + case_data["custom_fields"].values
      end
      path_array << file_path.path
    end
  end
    p_file = project.project_file
    path = path_array.join(',')
    unless p_file.nil?
     p_file.update_attributes(:csv_case => path, :case_download_at => Time.now)
    else
     project.create_project_file(:csv_case => path, :case_download_at => Time.now)
    end
    p path
	p "Sucessfully generated Case csv"
   rescue
   	p "Desk credentials has expired"
   end
 else
	p "The requested project does not exist"
end
