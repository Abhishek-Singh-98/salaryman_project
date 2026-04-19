class ApplicationController < ActionController::Base

  def current_employee
    @current_employee ||= Employee.find_by(id: session[:employee_id]) if session[:employee_id]
  end

  def authenticate_user
    unless current_employee
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # helper_method :current_employee
end
