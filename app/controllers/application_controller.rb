class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  skip_before_action :verify_authenticity_token

  def current_hr_employee
    @hr_employee ||= Employee.find_by(id: session[:employee_id], role: :hr_manager, active: true) if session[:employee_id]
  end

  def authenticate_user
    unless current_hr_employee
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

end
