class ChangeSalaryNullConstraintInEmployee < ActiveRecord::Migration[7.0]
  def change
    change_column_null :employees, :salary, true
  end
end
