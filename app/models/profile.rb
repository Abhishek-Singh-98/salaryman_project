class Profile < ApplicationRecord
  belongs_to :employee

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :email, uniqueness: { case_sensitive: false }
  validates :phone_number, length: { maximum: 14 },
                          format: { 
                            with: /\A\+?[0-9]+\z/, 
                            message: "must start with an optional + and contain only numbers" 
                          }, allow_blank: true
end
