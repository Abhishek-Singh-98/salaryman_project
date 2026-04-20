FactoryBot.define do
  factory :profile do
    email { "john.doe@example.com" }
    phone_number { "+1234567890" }
    date_of_birth { "1990-01-01" }
    joining_date { "2020-01-01" }
    association :employee
  end
end