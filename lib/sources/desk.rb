require 'desk'
class DeskDb < ActiveRecord::Base
  def initialize(api_resource, params = {}, page=1, per_page=10)
    @api_resource = api_resource
    @params = params
    desk_config
    @page = page
    @per_page = per_page
  end
  #This method used for execute the desk API
  def get_data
    url = "#{@params[:subdomain]}/api/v2/#{@api_resource}?page=#{@page}&per_page=#{@per_page}"
    Desk.get(url, options={}, raw=false)
  end
  #This method used for execute the desk API
  def get_link_data
    url = "#{@params[:subdomain]}#{@api_resource}"
    Desk.get(url, options={}, raw=false)
  end
  #This method used for configuare desk API
  def desk_config
    Desk.configure do |config|
    config.support_email = @params[:support_email]
    config.subdomain = @params[:subdomain]
    config.consumer_key = @params[:consumer_key]
    config.consumer_secret = @params[:consumer_secret]
    config.oauth_token = @params[:oauth_token]
    config.oauth_token_secret = @params[:oauth_token_secret]
  end
  end
 end