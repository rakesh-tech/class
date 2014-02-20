class ApplicationController < ActionController::Base
  #protect_from_forgery
  #This method used for run the ruby script to generate the csv file by using params
  def script_method file, id
   system("ruby lib/#{file}.rb #{id}")
  end
  #This method used for download the csv file
  def download_csv id, fetch, type
  	project = Project.find(id)

    case type
      when 'case'
        #Download case file
        send_file project.project_file.csv_case.split(',').fetch(fetch.to_i)
      when 'group'
        #Download group file
        send_file project.project_file.csv_group.split(',').fetch(fetch.to_i)
      when 'company'
       #Download company file
        send_file project.project_file.csv_company.split(',').fetch(fetch.to_i)
      when 'attachment'
       #Download attachment file
        send_file project.project_file.csv_attachment.split(',').fetch(fetch.to_i)
      when 'twitter'
       #Download company file
        send_file project.project_file.csv_twitter.split(',').fetch(fetch.to_i)
      when 'facebook'
       #Download facebook file
        send_file project.project_file.csv_facebook.split(',').fetch(fetch.to_i)
       when 'reply'
       #Download reply file
        send_file project.project_file.csv_reply.split(',').fetch(fetch.to_i)
       when 'note'
       #Download note file
        send_file project.project_file.csv_note.split(',').fetch(fetch.to_i)
      else
        # Unknown resource
        raise "Unknown resource type"
      end
    end
end
