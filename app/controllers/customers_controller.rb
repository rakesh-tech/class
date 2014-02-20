require_dependency 'lib/sources/desk.rb'
require 'csv'
class CustomersController < ApplicationController
  before_filter :authenticate_user!
  # This method used for get the desk.com customers details using desk API and passed to script method which generates a new customer csv file
  def index
    begin
    project = Project.find(params[:project_id])
  	response = DeskDb.new('customers',project)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    script_method 'customer', params[:project_id]
    render :json => {:project_id => "#{project.id}",:resource => "customers"  }
  rescue
    render :json => {:failure => "Desk credentials Expired" }
   end
  end
  #This method used for  download the csv file
  def show
    project = Project.find(params[:id])
    if params.has_key?('get_user')
     send_file project.project_file.csv_user.split(',').fetch(params[:fetch].to_i)
    else
     send_file project.project_file.csv_customer.split(',').fetch(params[:fetch].to_i)
    end
  end

  # This method used for get the desk.com users details using desk API and passed to script method which generates a new user csv file
  def get_users
    begin
    project = Project.find(params[:id])
  	response = DeskDb.new('users',project)
    converted_response = JSON.parse(response.get_data._embedded.to_json)["entries"]
    script_method 'user', params[:id]
    render :json => {:project_id => "#{project.id}",:resource => "customers_get_users"  }
  rescue
    render :json => {:failure => "Desk credentials Expired" }
   end
  end
end
