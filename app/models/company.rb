class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  belongs_to :country


  validates :name, :email_domain, presence: true, uniqueness: true
end
