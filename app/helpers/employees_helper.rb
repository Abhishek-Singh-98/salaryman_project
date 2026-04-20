module EmployeesHelper

  def assign_job_title_to_employee
    job_title_id = params[:employee][:job_title_id]
    if job_title_id.present?
      EmployeeJobTitle.create(employee: @employee, job_title_id: job_title_id)
    end
  end

  def check_and_update_job_title
    job_title_id = params[:employee][:job_title_id]
    if job_title_id.present?
      employee_job_title = EmployeeJobTitle.find_by(employee: @employee)
      if employee_job_title
        employee_job_title.update(job_title_id: job_title_id)
      else
        EmployeeJobTitle.create(employee: @employee, job_title_id: job_title_id)
      end
    end
  end
end
