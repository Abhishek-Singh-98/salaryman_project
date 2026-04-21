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
  validates :salary, numericality: { greater_than: 0 }, allow_blank: true

  validates_associated :profile

  scope :only_active_employees, -> { where(active: true, role: :employee) }

  before_validation :assign_employee_number, if: :new_record?
  
  private

  def assign_employee_number
    return unless self.company_id

    last_employee = Employee.where(company_id: self.company_id).order(:created_at).last
    self.emp_number = if last_employee&.emp_number =~ /\A(.+)-EMP(\d+)\z/
      prefix, number = $1, $2.to_i + 1
      "#{prefix}-EMP#{number}"
    else
      "#{self.company.company_code.upcase}-EMP1"
    end
  end
end
