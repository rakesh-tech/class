class AddCsvFacebookAndCsvTwitterToProjectFiles < ActiveRecord::Migration
  def change
    add_column :project_files, :csv_facebook, :string
    add_column :project_files, :csv_twitter, :string
  end
end
