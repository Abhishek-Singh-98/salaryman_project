module AuthHelper
  def assign_employee_number_and_role_to_hr
    last_employee = Employee.where(company_id: @company.id).order(:created_at).last
    @employee.company = @company
    @employee.emp_number = if last_employee 
      prefix = last_employee.emp_number[/[A-Za-z]+/]
      number = last_employee.emp_number[/\d+/].to_i + 1
      "#{prefix}#{number}"
    else
      "#{@company.name[0..2].upcase}001"
    end
    @employee.role = 'hr_manager'
    #these are hardcoded as of now, i will change this in next commits
    @employee.full_name = profile_params[:email].split('@').first.capitalize
    @employee.salary = 50000
  end

  def check_email_presence_and_uniqueness
    email = params[:auth][:email]
    if email.blank?
      render json: { error: 'Email is required' }, status: :unprocessable_entity
    elsif Profile.exists?(email: email)
      render json: { error: 'Email has already been taken' }, status: :unprocessable_entity
    end
  end
end
