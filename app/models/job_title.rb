class JobTitle < ApplicationRecord
  has_many :employee_job_titles, dependent: :destroy
  has_many :employees, through: :employee_job_titles
  
  enum department: { engineering: 0, hr: 1, sales: 2, marketing: 3, finance: 4 }

  validates :title, :department, presence: true
end
