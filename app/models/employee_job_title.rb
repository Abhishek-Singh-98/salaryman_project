class EmployeeJobTitle < ApplicationRecord
  belongs_to :employee
  belongs_to :job_title

  validates :employee_id, :job_title_id, presence: true

  validates :employee_id, uniqueness: { scope: :job_title_id, message: "can only have one association with a specific job title" }
end
