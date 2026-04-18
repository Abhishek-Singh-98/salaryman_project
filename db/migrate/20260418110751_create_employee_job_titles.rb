class CreateEmployeeJobTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_job_titles do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :job_title, null: false, foreign_key: true
      t.timestamps
    end
    add_index :employee_job_titles, [:employee_id, :job_title_id], unique: true
  end
end
