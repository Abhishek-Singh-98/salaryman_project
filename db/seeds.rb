# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

#before everything we need to destroy all the data
Company.destroy_all
Employee.destroy_all
Country.destroy_all
JobTitle.destroy_all
# Create sample countries
country1 = Country.create!(name: "Singapore")
country2 = Country.create!(name: "India")


# Create sample companies
company = Company.create!(
  name: "Incubyte Consulting LLP",
  email_domain: "incuinterview.com",
  address: "123 Tech Street, Ahmedabad, Gujarat",
  phone_number: "+912555012387",
  country: country2,
)


# Create sample job titles
job_title1 = JobTitle.create!(
  title: "Engineering",
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

job_title3 = JobTitle.create!(
  title: "Sales Executive",
  description: "Manages Client and Project Handling",
  department: 2,
  abbreviation: "SEO"
)

now = Time.current

first_names = File.readlines(Rails.root.join('./db/first_name.txt'), chomp: true)
last_names = File.readlines(Rails.root.join('./db/last_name.txt'), chomp: true)
puts 'seeding employees have started'
default_password = BCrypt::Password.create('pass@123', cost: BCrypt::Engine::MIN_COST)
processed_count = -1
employees = 10_000.times.map do
  processed_count +=1

  {
    full_name: "#{first_names.sample} #{last_names.sample}",
    salary: rand(30_000..150_000),
    role: (processed_count > 9980) ? 0 : 1,
    password_digest: default_password,
    active: true,
    company_id: company.id,
    emp_number: "#{company.company_code.upcase}-EMP#{processed_count + 1}",
    created_at: Time.current,
    updated_at: Time.current

  }
end


employees.each_slice(10000) { |batch| Employee.insert_all(batch) }

employee_ids = Employee.where(created_at: now..).pluck(:id)
puts "Inserted #{employee_ids.length} employees"


puts "Seeding profiles..."

profile_rows = employee_ids.map.with_index do |employee_id, i|
  {
    employee_id:   employee_id,
    email:         "employee#{employee_id}@incuinterview.com",
    phone_number:  "+91#{rand(1_000_000_000..9_999_999_999)}",
    date_of_birth: rand(25..45).years.ago.to_date,
    joining_date:  rand(1..5).years.ago.to_date,
    created_at:    now,
    updated_at:    now
  }
end

profile_rows.each_slice(10000) { |batch| Profile.insert_all(batch) }
puts "Inserted #{profile_rows.length} profiles"

puts "Seeding job title associations..."

hr_employee_ids = Employee.where(role: :hr_manager).pluck(:id)
eng_employee_ids = Employee.where(role: :employee).pluck(:id)

hr_job_title_rows = hr_employee_ids.map do |employee_id|
  {
    employee_id:  employee_id,
    job_title_id: job_title2.id,
    created_at:   now,
    updated_at:   now
  }
end

hr_job_title_rows.each_slice(1000) { |batch| EmployeeJobTitle.insert_all(batch) }
puts "Inserted #{hr_job_title_rows.length} job title associations for HR"

new_count = -1
eng_job_title_rows = eng_employee_ids.map do |employee_id|
  new_count += 1

  {
    employee_id:  employee_id,
    job_title_id: (new_count > 9600) ? job_title3.id : job_title1.id,
    created_at:   now,
    updated_at:   now
  }
end

eng_job_title_rows.each_slice(1000) { |batch| EmployeeJobTitle.insert_all(batch) }
puts "Inserted #{new_count} job title associations for ENG and SOE"


puts "\nDone! Totals:"
puts "  Employees:        #{Employee.count}"
puts "  Profiles:         #{Profile.count}"
puts "  Job associations: #{EmployeeJobTitle.count}"
puts "Seed data created successfully!"
puts "Sample company codes: TECH123, SALARY456"
