class CreateJobTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :job_titles do |t|
      t.string :title, null: false
      t.string :description
      t.integer :department, default: 0
      t.string :abbreviation
      t.timestamps
    end
  end
end
