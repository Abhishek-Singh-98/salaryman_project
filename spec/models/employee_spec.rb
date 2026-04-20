require 'rails_helper'

RSpec.describe Employee, type: :model do
  let!(:employee) { create(:employee) }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_one(:employee_job_title).dependent(:destroy) }
    it { should have_one(:job_title).through(:employee_job_title) }
    it { should accept_nested_attributes_for(:profile) }
  end

  describe 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:emp_number) }
    it { should validate_numericality_of(:salary).is_greater_than(0) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values([:hr_manager, :employee]) }
  end

  describe 'secure password' do
    it { should have_secure_password }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      expect(employee).to have_attributes(
        full_name: employee.full_name,
        salary: employee.salary,
        emp_number: employee.emp_number,
        role: employee.role
      )
    end
  end

  describe 'edge cases' do
    context 'with duplicate emp_number' do
      it 'is invalid with duplicate emp_number' do
        allow(Employee).to receive_message_chain(:where, :order, :last).and_return(nil)
        duplicate = build(:employee, emp_number: employee.emp_number, company: employee.company)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:emp_number]).to include("has already been taken")
      end
    end

    context 'with zero salary' do
      it 'is invalid with zero salary' do
        employee = build(:employee, salary: 0)
        expect(employee).not_to be_valid
        expect(employee.errors[:salary]).to include("must be greater than 0")
      end
    end

    context 'with negative salary' do
      it 'is invalid with negative salary' do
        employee = build(:employee, salary: -1000)
        expect(employee).not_to be_valid
        expect(employee.errors[:salary]).to include("must be greater than 0")
      end
    end

    context 'without company' do
      it 'is invalid without company' do
        employee = build(:employee, company: nil)
        expect(employee).not_to be_valid
      end
    end

    context 'with very long full_name' do
      it 'is valid with long full_name' do
        long_name = "A" * 255
        employee = build(:employee, full_name: long_name)
        expect(employee).to be_valid
      end
    end

    context 'role transitions' do
      it 'can be hr_manager' do
        hr = create(:employee, :hr_manager, company: employee.company)
        expect(hr.role).to eq("hr_manager")
      end

      it 'defaults to employee' do
        expect(employee.role).to eq("employee")
      end
    end
  end
end