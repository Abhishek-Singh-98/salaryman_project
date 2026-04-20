FactoryBot.define do
  factory :employee_job_title do
    association :employee
    association :job_title
  end
end