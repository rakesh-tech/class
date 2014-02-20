require_dependency 'lib/sources/desk.rb'
require 'csv'
class CompaniesController < ApplicationController
	before_filter :authenticate_user!
  # This method used for get the desk.com company details using desk API and passed to script method which generates a new company csv file
  def index
    begin
      project = Project.find(params[:project_id])
      response = DeskDb.new('companies',project)
      converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
      script_method 'company', params[:project_id]
     render :json => {:project_id => "#{project.id}",:resource => "companies"  }
    rescue
      render :json => {:failure => "Desk credentials Expired" }
     end
  end
  #This method used for  download the csv file
  def show
    download_csv params[:id], params[:fetch], 'company'
  end
end
