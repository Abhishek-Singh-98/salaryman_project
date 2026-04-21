module JobTitleAssignment
  extend ActiveSupport::Concern

  included do
   
  end

  def assign_job_title_to_employee(employee, job_title_id)
    return unless job_title_id.present?
    EmployeeJobTitle.find_or_initialize_by(employee: employee)
                    .update!(job_title_id: job_title_id)
  end
end