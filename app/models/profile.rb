class Profile < ApplicationRecord
  belongs_to :employee

  validates :email, :joining_date, presence: true
end
