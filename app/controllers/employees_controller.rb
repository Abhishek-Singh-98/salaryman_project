class EmployeesController < ApplicationController
  before_action :authenticate_user
  before_action :set_company
  before_action :set_employee, :validate_colleague, only: [:show, :update, :destroy]
  before_action :check_email_presence, :check_email_uniqueness, only: [:create, :update]


  def index
    @employees = Employee.includes(:profile).where(company: @company).only_active_employees
    if @employees.empty?
      render json: { message: 'No employees found yet' }, status: :ok
    else
      render json: @employees.to_json(include: :profile), status: :ok
    end
  end


  def show
    if @employee && @employee.company == @company
      render json: @employee.to_json(include: :profile), status: :ok
    else
      render json: { message: 'Employee not found' }, status: :not_found
    end
  end


  def new
    #redundant since we are not rendering any form, but kept for consistency
  end


  def create
    @employee = Employee.new(employee_params)
    @employee.company = @company
    @employee.role = :employee

    if @employee.save
      render json: @employee.to_json(include: :profile), status: :created
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @employee.update(employee_params)
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
  end

  def validate_colleague
    unless @employee && @employee.company == @company
      render json: { message: 'Employee not found' }, status: :not_found
    end
  end


  def employee_params
    params.require(:employee).permit(:full_name, :emp_number, :salary, :password, :password_confirmation, profile_attributes: [:id, :email, :phone_number, :date_of_birth, :joining_date])
  end


  def set_company
    @company = current_employee.company
  end

  def check_email_presence
    profile_attrs = params[:employee][:profile_attributes].presence || {}
    @email = profile_attrs[:email]
    if @email.blank?
      render json: { error: 'Email is required' }, status: :unprocessable_entity
    end
  end

  def check_email_uniqueness
    # email = params[:employee][:profile_attributes][:email]
    existing_profile = Profile.find_by(email: @email)
    if existing_profile && existing_profile.employee != @employee
      render json: { error: 'Email has already been taken' }, status: :unprocessable_entity
    end
  end
end
