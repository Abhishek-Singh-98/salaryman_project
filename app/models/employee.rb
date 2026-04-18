class Employee < ApplicationRecord
  belongs_to :company
  has_one :profile, dependent: :destroy
  has_one :employee_job_title, dependent: :destroy
  has_one :job_title, through: :employee_job_title

  enum role: { hr_manager: 0, employee: 1 }

  validates :full_name, :salary, :emp_number, presence: true
  validates :emp_number, uniqueness: true
end
