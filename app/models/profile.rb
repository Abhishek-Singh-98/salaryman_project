class Profile < ApplicationRecord
  belongs_to :employee

  validates :email, presence: true
end
