class AddDownloadAtToAllFields < ActiveRecord::Migration
    def change
    add_column :project_files, :company_download_at, :datetime
    add_column :project_files, :case_download_at, :datetime
    add_column :project_files, :attachment_download_at, :datetime
    add_column :project_files, :customer_download_at, :datetime
    add_column :project_files, :note_download_at, :datetime
    add_column :project_files, :reply_download_at, :datetime
    add_column :project_files, :user_download_at, :datetime
    add_column :project_files, :facebook_user_download_at, :datetime
    add_column :project_files, :twitter_user_download_at, :datetime
    add_column :project_files, :group_download_at, :datetime
  end
end
