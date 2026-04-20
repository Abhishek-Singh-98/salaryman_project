class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  belongs_to :country, required: true


  validates :name, :email_domain, :company_code, presence: true, uniqueness: true


  before_validation :generate_company_code, on: :create

  private
  def generate_company_code
    return if company_code.present? || name.blank?

    self.company_code = "#{name[0..3].upcase}#{SecureRandom.hex(4).upcase}"
  end
end
