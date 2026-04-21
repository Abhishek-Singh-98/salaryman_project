module SalaryInsightConcern
  extend ActiveSupport::Concern

  included do
    # before_action :set_salary_insight, only: [:show, :edit, :update, :destroy]
  end

  def average_salary_calculate(salaries)
    return 0 if salaries.empty?

    (salaries.sum.to_f / salaries.length).round(2)
  end

  def filter_employees_by_params(company_id = nil, country_id, role, job_title_id)
    @employees = Employee.where(company_id: company_id) if company_id.present?

    @employees = if @employees
                  @employees.joins(:company)
                            .where(companies: { country_id: country_id }) if country_id.present?
                else
                  Employee.joins(:company)
                        .where(companies: { country_id: country_id }) if country_id.present?
                end
                           
    @employees = @employees.where(role: role) if role.present?

    if job_title_id.present?
      @employees = @employees.joins(:employee_job_title)
                           .where(employee_job_titles: { job_title_id: job_title_id })
    end
  end
end