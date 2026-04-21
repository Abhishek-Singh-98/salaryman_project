class SalaryInsightsController < ApplicationController
  include SalaryInsightConcern
  before_action :authenticate_user

  def index
    company_id = (insight_params[:my_company_insight] == 'true') ? current_hr_employee.company_id : nil
    country_id = insight_params[:country_id] ? insight_params[:country_id] : Country.pluck(:id)
    role = insight_params[:role].presence
    job_title_id = insight_params[:job_title_id].presence

    filter_employees_by_params(company_id, country_id, role, job_title_id)

    # Grouping by role and calculate insights to split insights into different sections
    insights = {}
    employees_by_role = @employees.group_by(&:role)

    employees_by_role.each do |role_key, role_employees|
      salaries = role_employees.map(&:salary)
      insights[role_key] = calculate_salary_stats(salaries)
    end

    # Overall insights
    all_salaries = @employees.pluck(:salary)
    insights[:overall] = calculate_salary_stats(all_salaries) if all_salaries.present?

    render json: {
      insights: insights,
      country_id: country_id,
      filters: { role: role, job_title_id: job_title_id, country_id: country_id }
    }, status: :ok
  end

  private

  def insight_params
    params.permit(:country_id, :role, :job_title_id, :my_company_insight)
  end

  def calculate_salary_stats(salaries)
    return {} if salaries.empty?

    {
      average: average_salary_calculate(salaries),
      min: salaries.min,
      max: salaries.max,
      count: salaries.length
    }
  end
end
