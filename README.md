# Salaryman Project

A full-stack salary management system built with Ruby on Rails 7 (API backend) and React (frontend), designed as a hands-on practice project for learning Rails architecture patterns, RESTful API design, and React integration.

The system allows HR managers to manage employees, track salaries, assign job titles, and view salary insights — all scoped to their own company.

## What the App Does
- **Authentication** — HR managers sign up and log in using a company code. Sessions are cookie-based using Rails' built-in session store.
- **Employee Management** — HR managers can create, view, update, and soft-delete employees within their company. Each employee has a separate profile record storing contact details.
- **Job Title Assignment** — Each employee is linked to a job title through a join table, supporting many job titles across departments (Engineering, HR, Sales, Marketing, Finance).
- **Salary Insights** — Aggregated salary statistics (average, min, max, count) filterable by country, role, and job title across companies.
- **Pagination** — Employee list is paginated server-side using Kaminari, with 25 records per page by default.
- **Multi-tenancy** — All employee data is scoped to the HR manager's company. Accessing another company's data returns a 404.

## Architecture
This project uses a monolithic Rails app with a React SPA frontend — sometimes called the "Rails + Vite" pattern.

```
Browser
  └── React (Vite, port 5173 in dev)
        └── fetch() API calls
              └── Rails 7 (port 3000)
                    ├── Controllers (JSON responses only)
                    ├── Models (ActiveRecord + PostgreSQL)
                    └── Session store (cookie-based auth)
Rails serves one HTML page (home#index) which boots the React app. React handles all routing client-side via React Router. All other Rails routes return JSON.

```

### Backend structure
```
app/
├── controllers/
│   ├── application_controller.rb       # auth helpers, current_hr_employee
│   ├── auth_controller.rb              # signup, login, logout
│   ├── employees_controller.rb         # CRUD for employees
│   ├── salary_insights_controller.rb   # aggregated salary stats
│   ├── job_titles_controller.rb        # list job titles
│   ├── countries_controller.rb         # list countries
│   └── concerns/
│       ├── pagination_concern.rb       # kaminari pagination helpers
│       ├── job_title_assignment.rb     # find_or_initialize job title link
│       └── salary_insight_concern.rb   # filter + stats calculation
├── models/
│   ├── employee.rb                     # has_secure_password, enums, scopes
│   ├── profile.rb                      # email/phone validations
│   ├── company.rb                      # auto-generates company_code
│   ├── job_title.rb                    # department enum
│   ├── employee_job_title.rb           # join table
│   └── country.rb

```

### Frontend structure

```
app/frontend/
├── entrypoints/
│   └── app.jsx                 # React root, mounts to DOM
├── pages/
│   ├── Login.jsx
│   ├── Signup.jsx
│   ├── Dashboard.jsx
│   ├── EmployeesList.jsx       # paginated employee table
│   ├── ShowEmployee.jsx
│   ├── NewEmployee.jsx
│   ├── EditEmployee.jsx
│   ├── MyProfile.jsx
│   └── SalaryInsight.jsx
└── components/
    └── Navbar.jsx

```
### Database Schema
```
countries
  └── companies (country_id)
        └── employees (company_id)
              ├── profiles (employee_id)          -- 1:1
              └── employee_job_titles (employee_id)  -- join table
                    └── job_titles (job_title_id)

```

### Key design decisions:

- Employee credentials (password_digest) live on the employees table, contact info (email, phone_number) lives on profiles. This separates authentication data from contact data.
- Soft delete — employees are never hard deleted. active: false deactivates them.
- emp_number is auto-generated from the company code on creation (e.g. TECH1A2B-EMP1).
- company_code is auto-generated on company creation using the first 4 letters of the name + a random hex suffix.

---

## Key Gems

| Gem | Purpose |
|---|---|
| rails ~> 7.0	| Core framework — API routing, ActiveRecord, sessions |
| pg	| PostgreSQL adapter |
| bcrypt	| Password hashing via has_secure_password |
| kaminari	| Server-side pagination — .page().per() on ActiveRecord scopes |
| puma	| Web server |
| rspec-rails	| Test framework |
| factory_bot_rails	| Test factories for generating model instances |
| faker	| Fake data generation in factories |
| shoulda-matchers	| One-liner model/association matchers in RSpec |
| database_cleaner-active_record	| Cleans DB state between test runs |
| rubocop	| Ruby style linter |
Frontend (via Vite + npm):


## Getting Started

### Prerequisites
- Ruby 3.2.2
- PostgreSQL
- Node.js (for Vite frontend)

### Setup
```
# Clone the repo
git clone https://github.com/Abhishek-Singh-98/salaryman_project.git
cd salaryman_project

# Install Ruby dependencies
bundle install

# Install JS dependencies
npm install

# Create and migrate the database
rails db:create db:migrate

# Seed with sample data (companies, job titles, HR manager)
rails db:seed
```

### Running the app
You need two terminals — one for Rails, one for Vite:
```bash
# Terminal 1 — Rails backend
rails server

# Terminal 2 — Vite frontend (with hot module reload)
npx vite
Then open http://localhost:3000.
```

# Useful Commands
```bash
# Run all tests
bundle exec rspec

# Open Rails console (useful for checking data)
rails console

# Check all registered routes
rails routes

# Check routes for a specific controller
rails routes -c employees

# Reset DB and reseed from scratch
rails db:drop db:create db:migrate db:seed

# Check current schema version
rails db:version

# See pending migrations
rails db:migrate:status
```

## API Endpoints
```
Method	Path	Description	Auth required
POST	/signup	Register a new HR manager	No
POST	/login	Log in	No
DELETE	/logout	Log out	Yes
GET	/employees?page=1	List employees (paginated)	Yes
GET	/employees/:id	Show employee	Yes
POST	/employees	Create employee	Yes
PUT	/employees/:id	Update employee	Yes
DELETE	/employees/:id	Deactivate employee	Yes
GET	/job_titles	List all job titles	No
GET	/countries	List all countries	Yes
GET	/salary_insights	Salary stats with filters	Yes
```
