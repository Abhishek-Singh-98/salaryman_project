# Salaryman Project

## Plan for design, pattern & schema

### Tables

- **Employee**
  - full_name
  - salary
  - emp_number
  - company_id (fk)
  - password
  - role (enum)

- **Profile**
  - email
  - phone
  - image
  - joining_date
  - employee_id (fk)

- **Company**
  - name
  - email
  - address
  - country_id (fk)

- **Country**
  - name

- **Job-Title**
  - title
  - abbreviation
  - department (enum)

- **Employee-Job-Title**
  - employee_id (fk)
  - job_title_id (fk)

## Associations as of now

- **Company**
  - has_many :employees, dependent: :destroy
  - belongs_to :country

- **Country**
  - has_many :companies

- **Employee**
  - belongs_to :company
  - has_one :profile, dependent: :destroy
  - has_one :employee_job_title, dependent: :destroy
  - has_one :job_title, through: :employee_job_title

- **Profile**
  - belongs_to :employee

- **JobTitle**
  - has_many :employee_job_titles, dependent: :destroy
  - has_many :employees, through: :employee_job_titles

- **EmployeeJobTitle**
  - belongs_to :employee
  - belongs_to :job_title

## Notes

This README contains a simple schema overview and entity relationship plan for the Salaryman Project.