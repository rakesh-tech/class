class Project < ActiveRecord::Base
	belongs_to :user
	scope :get_project, lambda {|p_id| where("id = ?", p_id)  }
	validates :name, :presence => {:message => "Please enter Project name"}
    validates :support_email, :presence => {:message => "Please enter Support Eemail"}
    validates :subdomain, :presence => {:message => "Please enter Subdomain"}
    validates :consumer_key, :presence => {:message => "Please enter Consumer key"}
    validates :consumer_secret, :presence => {:message => "Please enter Consumer Secret"}
    validates :oauth_token, :presence => {:message => "Please enter Oauth Token"}
    validates :oauth_token_secret, :presence => {:message => "Please enter Oauth Token Secret"}
    has_one :project_file
end
