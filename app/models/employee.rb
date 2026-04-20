class Employee < ApplicationRecord
  has_secure_password

  belongs_to :company
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_one :employee_job_title, dependent: :destroy
  has_one :job_title, through: :employee_job_title

  enum role: { hr_manager: 0, employee: 1 }

  validates :full_name, :emp_number, presence: true
  validates :emp_number, uniqueness: true
  validates :salary, numericality: { greater_than: 0 } 

  scope :only_active_employees, -> { where(active: true, role: :employee) }

  before_save :assign_employee_number, if: :new_record?
  
  private

  def assign_employee_number
    last_employee = Employee.where(company_id: self.company_id).order(:created_at).last
    self.emp_number = if last_employee 
      prefix = last_employee.emp_number[/[A-Za-z]+/]
      number = last_employee.emp_number[/\d+/].to_i + 1
      "#{prefix}#{number}"
    else
      "#{self.company.name[0..2].upcase}001"
    end
  end
end
