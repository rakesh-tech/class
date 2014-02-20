require_dependency 'lib/sources/desk.rb'
require 'csv'
class TwitterUsersController < ApplicationController
	before_filter :authenticate_user!
    # This method used for get the desk.com twitter user details using desk API and passed to script method which generates a new twitter user csv file
  def index
    begin
      project = Project.find(params[:project_id])
      response = DeskDb.new('twitter_users',project)
      converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
      script_method 'twitter_user', params[:project_id]
     render :json => {:project_id => "#{project.id}",:resource => "twitter_users"  }
    rescue
      render :json => {:failure => "Desk credentials Expired" }
     end
  end
  #This method used for  download the csv file
  def show
    download_csv params[:id], params[:fetch], 'twitter'
  end
end
