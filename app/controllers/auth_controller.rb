class AuthController < ApplicationController
  include AuthHelper
  before_action :authenticate_user, only: [:logout]
  before_action :check_email_presence_and_uniqueness, :check_password_match, only: [:sign_up]
  before_action :validate_company_code, only: [:sign_up, :login]
  before_action :validate_email, only: [:login]

  def sign_up
    @employee = Employee.new(sign_up_params)
    assign_employee_number_and_role_to_hr
    @employee.build_profile(profile_params)
    if @employee.save
      session[:employee_id] = @employee.id
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    if @hr_employee&.authenticate(login_params[:password])
      session[:employee_id] = @hr_employee.id
      render json: @hr_employee, status: :ok
    else
      render json: { error: 'Please check your email and password' }, status: :unauthorized
    end
  end

  def logout
    session.delete(:employee_id)
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def login_params
    params.require(:auth).permit(:email, :password, :company_code)
  end

  def sign_up_params
    params.require(:auth).permit(:password, :password_confirmation,:company_id,:role, :emp_number, :full_name)
  end

  def profile_params
    params.require(:auth).permit(:email, :phone_number, :date_of_birth, :joining_date)
  end

  def validate_company_code
    company_code = params[:auth][:company_code]
    @company = Company.find_by(company_code: company_code)
    unless @company
      render json: { error: 'Invalid company code' }, status: :unprocessable_entity
    end
  end

  def validate_email
    email = params[:auth][:email]
    @hr_employee ||= Profile.find_by(email: email)&.employee
    unless @hr_employee
      render json: { error: 'Email not found' }, status: :unprocessable_entity
    end
  end

  def check_password_match
    password = params[:auth][:password]
    password_confirmation = params[:auth][:password_confirmation]
    unless password == password_confirmation
      render json: { error: 'Password and confirmation do not match' }, status: :unprocessable_entity
    end
  end
end
