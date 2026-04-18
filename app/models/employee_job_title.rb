class EmployeeJobTitle < ApplicationRecord
  belongs_to :employee
  belongs_to :job_title

  validates :employee_id, :job_title_id, presence: true
end
