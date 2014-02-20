class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.integer :project_id
      t.string :csv_group
      t.string :csv_user
      t.string :csv_case
      t.string :csv_customer
      t.string :csv_note
      t.string :csv_reply
      t.string :csv_attachment
      t.timestamps
    end
  end
end
