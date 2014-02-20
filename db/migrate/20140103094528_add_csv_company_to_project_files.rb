class AddCsvCompanyToProjectFiles < ActiveRecord::Migration
  def change
    add_column :project_files, :csv_company, :string
  end
end
