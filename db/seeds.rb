# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample countries
country1 = Country.create!(name: "United States")
country2 = Country.create!(name: "Japan")

# Create sample companies
company1 = Company.create!(
  name: "TechCorp Inc",
  email_domain: "techcorp.com",
  address: "123 Tech Street, Silicon Valley, CA",
  phone_number: "+1-555-0123",
  country: country1,
  company_code: "TECH123"
)

company2 = Company.create!(
  name: "SalaryMan Ltd",
  email_domain: "salaryman.jp",
  address: "456 Business Ave, Tokyo, Japan",
  phone_number: "+81-3-1234-5678",
  country: country2,
  company_code: "SALARY456"
)

# Create sample job titles
job_title1 = JobTitle.create!(
  title: "Software Engineer",
  description: "Develops software applications",
  department: 0, # IT/Engineering
  abbreviation: "SWE"
)

job_title2 = JobTitle.create!(
  title: "HR Manager",
  description: "Manages human resources",
  department: 1, # HR
  abbreviation: "HRM"
)

hr_manager = Employee.create!(
  full_name: "Alice Johnson",
  password: "password1",
  password_confirmation: "password1",
  role: :hr_manager,
  emp_number: "EMP001",
  salary: 120000,
  company: company1
)

hr_manager_profile = Profile.create!(
  email: "alice.johnson@techcorp.com",
  phone_number: "+919845724381",
  date_of_birth: "1985-06-15",
  joining_date: "2010-01-10",
  employee: hr_manager
)

puts "Seed data created successfully!"
puts "Sample company codes: TECH123, SALARY456"
