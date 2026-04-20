class ChangeJoiningDateType < ActiveRecord::Migration[7.0]
  def change
    change_column :profiles, :joining_date, :date
  end
end
