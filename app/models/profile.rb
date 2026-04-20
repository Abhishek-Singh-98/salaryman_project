class Profile < ApplicationRecord
  belongs_to :employee

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
