FactoryBot.define do
  factory :employee do
    full_name { "John Doe" }
    salary { 50000 }
    sequence(:emp_number) { |n| "TEC#{n.to_s.rjust(3, '0')}" }
    role { :employee }
    password { "password" }
    association :company

    trait :hr_manager do
      role { :hr_manager }
    end

    trait :with_profile do
      after(:create) do |employee|
        create(:profile, employee: employee)
      end
    end
  end
end