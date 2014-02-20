class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :user_name

  validates :email, :presence => {:message => "Please enter a valid email address"}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i , :message => "Please enter a valid email address",:if => Proc.new { |at| !at.email.blank? }
  validates_uniqueness_of :email, :message => " Email address already exists", :if => Proc.new { |at| !at.email.blank? }
  validates :first_name, :presence => {:message => "Please enter first name (2-40 characters)"}
  validates :first_name, :format=>{:with =>/^[a-zA-Z\-' ]+$/, :message => "First name can only contain letters, apostrophe or hyphen."}, :if => Proc.new { |at| !at.first_name.blank? }
  validates :first_name, :length=>{:in=>2..40, :message => "Please enter first name (2-40 characters)"}, :if => Proc.new { |at| !at.first_name.blank? }
  validates :last_name, :presence =>{:message => "Please enter last name (2-40 characters)"}
  validates :last_name, :format=>{:with =>/^[a-zA-Z\-' ]+$/, :message => "Last name can only contain letters, apostrophe or hyphen."}, :if => Proc.new { |at| !at.last_name.blank? }
  validates :last_name, :length=>{:in=>2..40, :message => "Please enter last name (2-40 characters)"}, :if => Proc.new { |at| !at.last_name.blank? }
  validates :user_name, :presence =>{:message => "Please enter user name (2-40 characters)"}
  #validates :user_name, :format=>{:with =>/^[a-zA-Z0-9\-' ]+$/, :message => "User name can only contain letters, apostrophe or hyphen."}, :if => Proc.new { |at| !at.last_name.blank? },
  validates :user_name, :length=>{:in=>2..40, :message => "Please enter User name (2-40 characters)"}, :if => Proc.new { |at| !at.last_name.blank? }
  validates :password, :presence =>{:message => "Please enter a password (8 - 32 characters)"}
  validates :password,:length=>{:in=>8..32,:message => "Please enter a password (8 - 32 characters)"},:if => Proc.new { |at| !at.password.blank? }
  validates :password_confirmation, :presence =>{:message => "Please re-enter your password"}
  validates_confirmation_of :password, :message=>"Sorry, that password doesn't match. Please try again.",:if => Proc.new { |at| !at.password_confirmation.blank? }
  has_many :projects

end
