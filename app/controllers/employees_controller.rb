class EmployeesController < ApplicationController
  include JobTitleAssignment
  include PaginationConcern
  before_action :authenticate_user
  before_action :set_company
  before_action :set_employee, :validate_colleague_employee, only: [:show, :update, :destroy]
  before_action :check_email_presence, :check_email_uniqueness, :check_phone_number, :check_job_title_presence, only: [:create, :update]


  def index
    employees = Employee.includes(:profile)
                        .where(company: @company)
                        .only_active_employees
    @employees = paginate(employees)
    if @employees.empty?
      render json: { message: 'No employees found yet' }, status: :ok
    else
      render json: {
        employees: @employees.as_json(include: :profile),
        pagination: pagination_metadata(@employees)
      }, status: :ok
    end
  end


  def show
    render json: @employee.as_json(include: [:profile, :employee_job_title]), status: :ok
  end


  def new
    #redundant since we are not rendering any form, but kept for consistency
  end


  def create
    @employee = Employee.new(employee_params)
    @employee.company = @company
    @employee.role = :employee

    if @employee.save
      assign_job_title_to_employee(@employee, params[:employee][:job_title_id])
      render json: @employee.to_json(include: :profile), status: :created
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @employee.update(employee_params)
      assign_job_title_to_employee(@employee, params[:employee][:job_title_id])
      render json: @employee.to_json(include: :profile), status: :ok
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    @employee.update(active: false)
    render json: { message: 'Employee deactivated successfully' }, status: :ok
  end


  private


  def set_employee
    @employee = Employee.find_by_id(params[:id])
    unless @employee && @employee.company == @company
       redirect_to root_path, alert: 'Employee not found', status: :not_found
    end
  end

  def validate_colleague_employee
    unless (@employee == current_hr_employee) || @employee.employee?
      redirect_to root_path, alert: 'Unauthorized access for this account', status: :unauthorized
    end
  end


  def employee_params
    params.require(:employee).permit(:full_name, :emp_number, :salary, :password, :password_confirmation, profile_attributes: [:id, :email, :phone_number, :date_of_birth, :joining_date])
  end


  def set_company
    @company = current_hr_employee.company
  end

  def check_email_presence
    profile_attrs = params.dig(:employee, :profile_attributes) || {}
    @email = profile_attrs[:email]
    if @email.blank?
      render json: { error: 'Email is required' }, status: :unprocessable_entity
    elsif !@email.match?(URI::MailTo::EMAIL_REGEXP)
      render json: { error: 'Email must be a valid email address' }, status: :unprocessable_entity
    end
  end

  def check_email_uniqueness
    existing_profile = Profile.find_by(email: @email)
    if existing_profile && existing_profile.employee != @employee
      render json: { error: 'Email has already been taken' }, status: :unprocessable_entity
    end
  end

  def check_phone_number
    profile_attrs = params[:employee][:profile_attributes].presence || {}
    phone_number = profile_attrs[:phone_number]
    if phone_number.blank?
      render json: { error: 'Phone number is required' }, status: :unprocessable_entity
    elsif phone_number.length > 13
      render json: { error: 'Phone number must be a maximum of 13 characters' }, status: :unprocessable_entity
    elsif !phone_number.match?(/\A\+?[0-9]+\z/)
      render json: { error: 'Phone number must contain only numbers & one plus sign at the beginning' }, status: :unprocessable_entity
    end
  end

  def check_job_title_presence
    job_title_id = params[:employee][:job_title_id]
    if job_title_id.blank? || !JobTitle.exists?(job_title_id)
      render json: { error: 'Valid job title is required' }, status: :unprocessable_entity
    end
  end
end
