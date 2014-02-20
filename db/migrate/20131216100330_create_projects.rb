class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :support_email
      t.string :subdomain
      t.string :consumer_key
      t.string :consumer_secret
      t.string :oauth_token
      t.string :oauth_token_secret
      t.string :user_id
      t.string :name
      t.timestamps
    end
  end
end
