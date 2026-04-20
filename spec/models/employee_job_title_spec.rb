require 'rails_helper'

RSpec.describe EmployeeJobTitle, type: :model do
  let(:employee_job_title) { create(:employee_job_title) }

  describe 'associations' do
    it { should belong_to(:employee) }
    it { should belong_to(:job_title) }
  end

  describe 'validations' do
    it { should validate_presence_of(:employee_id) }
    it { should validate_presence_of(:job_title_id) }
  end

  describe 'attributes' do
    it 'has expected associations' do
      expect(employee_job_title.employee).to be_present
      expect(employee_job_title.job_title).to be_present
    end
  end

  describe 'edge cases' do
    context 'with duplicate employee and job_title' do
      let(:error_message) { "can only have one association with a specific job title" } 

      it 'is invalid with duplicate pair' do
        duplicate = build(:employee_job_title,
                         employee: employee_job_title.employee,
                         job_title: employee_job_title.job_title)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:employee_id]).to include(error_message)
      end
    end

    context 'same employee different job_title' do
      let(:employee) { create(:employee) }
      let(:job_title1) { create(:job_title) }
      let(:job_title2) { create(:job_title) }

      it 'allows same employee with different job_titles' do
        create(:employee_job_title, employee: employee, job_title: job_title1)
        ejt2 = build(:employee_job_title, employee: employee, job_title: job_title2)
        expect(ejt2).to be_valid
      end
    end

    context 'same job_title different employees' do
      let(:job_title) { create(:job_title) }
      let(:employee1) { create(:employee) }

      before do
        allow(Employee).to receive_message_chain(:where, :order, :last)
          .and_return(employee1)
      end

      it 'allows same job_title with different employees' do
        employee2 = create(:employee, company: employee1.company)
        build(:employee_job_title, employee: employee1, job_title: job_title)
        ejt = build(:employee_job_title, employee: employee2, job_title: job_title)
        expect(ejt).to be_valid
      end
    end
  end
end