class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false
      t.bigint :salary, null: false
      t.string :emp_number, null: false, unique: true
      t.integer :role, default: 1
      t.timestamps
    end
    add_reference :employees, :company, foreign_key: true
    add_index :employees, :emp_number, unique: true
  end
end
