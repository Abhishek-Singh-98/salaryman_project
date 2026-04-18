# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_04_18_110751) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_domain", null: false
    t.string "address"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_job_titles", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "job_title_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "job_title_id"], name: "index_employee_job_titles_on_employee_id_and_job_title_id", unique: true
    t.index ["employee_id"], name: "index_employee_job_titles_on_employee_id"
    t.index ["job_title_id"], name: "index_employee_job_titles_on_job_title_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "full_name", null: false
    t.bigint "salary", null: false
    t.string "emp_number", null: false
    t.integer "role", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["emp_number"], name: "index_employees_on_emp_number", unique: true
  end

  create_table "job_titles", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.integer "department", default: 0
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone_number"
    t.date "date_of_birth"
    t.datetime "joining_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.index ["employee_id"], name: "index_profiles_on_employee_id"
  end

  add_foreign_key "companies", "countries"
  add_foreign_key "employee_job_titles", "employees"
  add_foreign_key "employee_job_titles", "job_titles"
  add_foreign_key "employees", "companies"
  add_foreign_key "profiles", "employees"
end
