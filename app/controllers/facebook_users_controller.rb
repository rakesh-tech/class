require_dependency 'lib/sources/desk.rb'
require 'csv'
class FacebookUsersController < ApplicationController

before_filter :authenticate_user!
 # This method used for get the desk.com facebook users details using desk API and passed to script method which generates a new face user csv file
  def index
    begin
      project = Project.find(params[:project_id])
      response = DeskDb.new('facebook_users',project)
      converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
      script_method 'facebook_user', params[:project_id]
     render :json => {:project_id => "#{project.id}",:resource => "facebook_users"  }
    rescue
      render :json => {:failure => "Desk credentials Expired" }
     end
  end
  #This method used for  download the csv file
  def show
   download_csv params[:id], params[:fetch], 'facebook'
  end
end
