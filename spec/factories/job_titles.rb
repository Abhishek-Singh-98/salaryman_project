FactoryBot.define do
  factory :job_title do
    title { "Software Engineer" }
    description { "Develops software applications" }
    department { 0 } # IT
    abbreviation { "SWE" }
  end
end