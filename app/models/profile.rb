class Profile < ApplicationRecord
  belongs_to :employee

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :phone_number, presence: true, length: { maximum: 13, message: "must be a maximum of 13 characters" }, format: { with: /\A[0-9\-\+\s\(\)]*\z/, message: "must contain only numbers, spaces, dashes, parentheses, or plus sign" }
end
