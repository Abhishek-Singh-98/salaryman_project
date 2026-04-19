class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false, unique: true
      t.string :email_domain, null: false, unique: true
      t.string :address 
      t.string :phone_number
      t.timestamps
    end
      add_index :companies, :name, unique: true
  end
end
