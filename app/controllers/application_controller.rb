class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  def current_employee
    @hr_employee ||= Employee.find_by(id: session[:employee_id]) if session[:employee_id]
  end

  def authenticate_user
    unless current_employee && current_employee.active? && current_employee.hr_manager?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # helper_method :current_employee
end
