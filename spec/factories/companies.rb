FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "TechCorp#{n}" }
    sequence(:email_domain) { |n| "techcorp#{n}.com" }
    address { "123 Main St" }
    phone_number { "+1234567890" }
    company_code { nil } # Let the model generate it
    association :country
  end
end