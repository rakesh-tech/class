require_dependency 'lib/sources/desk.rb'
require 'csv'
class CasesController < ApplicationController
  before_filter :authenticate_user!
  # This method used for get the desk.com case details by using API  and passed to script method which generates a new case csv file
  def index
    begin
    project = Project.find(params[:project_id])
    response = DeskDb.new('cases',project)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    script_method 'case', params[:project_id]
    render :json => {:project_id => "#{project.id}",:resource => "cases"  }
  rescue
    render :json => {:failure => "Desk credentials Expired" }
   end
  end
  #This method used for  download the csv file
  def show
    download_csv params[:id], params[:fetch], 'case'
  end
end
