class Employee < ApplicationRecord
  has_secure_password

  belongs_to :company
  has_one :profile, dependent: :destroy
  has_one :employee_job_title, dependent: :destroy
  has_one :job_title, through: :employee_job_title

  enum role: { hr_manager: 0, employee: 1 }

  validates :full_name, presence: true
  validates :salary, numericality: { greater_than: 0 } 
end
