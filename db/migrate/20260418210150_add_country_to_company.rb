class AddCountryToCompany < ActiveRecord::Migration[7.0]
  def change
    add_reference :companies, :country, foreign_key: true
  end
end
