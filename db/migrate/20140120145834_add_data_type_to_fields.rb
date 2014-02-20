class AddDataTypeToFields < ActiveRecord::Migration
  def change
  	 change_column :project_files, :csv_user, :text
  	 change_column :project_files, :csv_case, :text
  	 change_column :project_files, :csv_customer, :text
  	 change_column :project_files, :csv_company, :text
  	 change_column :project_files, :csv_group, :text
  	 change_column :project_files, :csv_note, :text
  	 change_column :project_files, :csv_reply, :text
  	 change_column :project_files, :csv_attachment, :text
  	 change_column :project_files, :csv_twitter, :text
  	 change_column :project_files, :csv_facebook, :text
  end
end
