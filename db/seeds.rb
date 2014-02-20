# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
User.create(:email => 'test@test.com', :password => '12345678', :password_confirmation => '12345678', :first_name => 'Test', :last_name => 'User', :user_name => 'testuser')
Project.create(:name=>'Sample Project', :user_id => 1, :support_email => 'test@test.com', :subdomain => 'https://testtech.desk.com', :consumer_key => 'nYJHVLoGO1mhYLhasANY', :consumer_secret => 'psd9nRU9tyA10MJJzaOv4wAGxXYGguke8IWE1r1I', :oauth_token => 'v3gFJqa2uiucLtjUaPKM', :oauth_token_secret => 'HJyg92LNG5gbwWeR7l1jRDGQQBcHLvFs3jSiq2j1')
Project.create(:name=>'Test Project', :user_id => 1, :support_email => 'sathiyarajr@techaffinity.com', :subdomain => 'https://dsfsdf.desk.com', :consumer_key => '9Cy4lMXfPWaWZ3BQfw7d', :consumer_secret => 'Tz3Ve3vRauMCcUABW1JRJGobTxoCp2Q4zlExKr9H', :oauth_token => 'YkhfCVu4V6iWLhkxKA9c', :oauth_token_secret => 'DIecd6C98qChzC0nJ1z6G2YfoqVlwp3cuuSO3ZRr')