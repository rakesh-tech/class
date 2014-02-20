class Account < ActiveRecord::Base
	establish_connection("remote_data")
end
