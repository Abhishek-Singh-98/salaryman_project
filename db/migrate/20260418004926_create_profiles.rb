class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :email, null: false, unique: true
      t.string :phone_number
      t.date :date_of_birth
      t.datetime :joining_date
      t.timestamps
    end
    add_reference :profiles, :employee, foreign_key: true
  end
end
