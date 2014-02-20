require_dependency 'lib/sources/desk.rb'
require 'csv'
class RepliesController < ApplicationController
  before_filter :authenticate_user!
    # This method used for get the desk.com notes details using desk API and passed to script method which generates a new note csv file
  def index
   begin
    project = Project.find(params[:project_id])
    response = DeskDb.new('cases',project)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    script_method 'reply', params[:project_id]
    render :json => {:project_id => "#{project.id}",:resource => "replies"  }
  rescue
    render :json => {:failure => "Desk credentials Expired" }
   end
  end
  #This method used for  download the csv file
  def show
   download_csv params[:id], params[:fetch], 'reply'
  end
end
