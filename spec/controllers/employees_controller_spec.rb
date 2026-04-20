require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:country) { create(:country) }
  let(:company) { create(:company, country: country) }
  let!(:hr_manager) { create(:employee, :hr_manager, full_name: 'HR Manager', company: company) }
  let(:employee) { create(:employee, :with_profile, company: company) }
  let(:other_company) { create(:company, name: 'NewTech Company', country: country) }
  let(:other_employee) { create(:employee, company: other_company) }

  before do
    session[:employee_id] = hr_manager.id
  end

  describe 'GET #index' do
    context 'with employees in company' do
      before { employee }

      it 'returns employees from current company' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.length).to eq(1)
        expect(json_response.first['id']).to eq(employee.id)
      end

      it 'includes profile data' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response.first).to have_key('profile')
      end
    end

    context 'with no employees' do
      it 'returns message' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('No employees found yet')
      end
    end

    context 'with employees from other companies' do
      before { other_employee }

      it 'does not return employees from other companies' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("No employees found yet")
      end
    end

    context 'when not authenticated' do
      before { session[:employee_id] = nil }

      it 'returns unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'with valid employee id' do
      it 'returns employee data' do
        get :show, params: { id: employee.id }
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(employee.id)
      end

      it 'includes profile data' do
        get :show, params: { id: employee.id }
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('profile')
      end
    end

    context 'with invalid employee id' do
      it 'returns not found' do
        get :show, params: { id: '99WRNG' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with employee from other company' do
      it 'returns not found' do
        get :show, params: { id: other_employee.id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        employee: {
          full_name: 'New Employee',
          emp_number: 'EMP999',
          salary: 45000,
          password: 'password123',
          password_confirmation: 'password123',
          profile_attributes: {
            email: 'new.employee@example.com',
            phone_number: '+1234567890',
            date_of_birth: '1995-05-15',
            joining_date: '2023-06-01'
          }
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new employee' do
        expect {
          post :create, params: valid_params
        }.to change(Employee, :count).by(1)
      end

      it 'creates a new profile' do
        expect {
          post :create, params: valid_params
        }.to change(Profile, :count).by(1)
      end

      it 'assigns to current company' do
        post :create, params: valid_params
        created_employee = Employee.last
        expect(created_employee.company).to eq(company)
      end

      it 'sets role to employee' do
        post :create, params: valid_params
        created_employee = Employee.last
        expect(created_employee.role).to eq('employee')
      end

      it 'returns created status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { valid_params.merge(employee: valid_params[:employee].merge(full_name: '')) }

      it 'does not create employee' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Employee, :count)
      end

      it 'returns unprocessable_entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with duplicate emp_number' do
      let!(:existing_employee) { create(:employee, :with_profile, full_name: 'My Employee', company: company) }
      let(:duplicate_params) { 
        {
        employee: {
          full_name: 'New Employee',
          emp_number: existing_employee.emp_number,
          salary: 45000,
          password: 'password123',
          password_confirmation: 'password123',
          profile_attributes: {
            email: existing_employee.profile.email,
            phone_number: '+1234567890',
            date_of_birth: '1995-05-15',
            joining_date: '2023-06-01'
          }
        }
      }
       }

      it 'does not create employee' do
        expect {
          post :create, params: duplicate_params
        }.not_to change(Employee, :count)
      end

      it 'returns unprocessable_entity status' do
        post :create, params: duplicate_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with password mismatch' do
      let(:mismatch_params) { valid_params.merge(employee: valid_params[:employee].merge(password_confirmation: 'different')) }

      it 'does not create employee' do
        expect {
          post :create, params: mismatch_params
        }.not_to change(Employee, :count)
      end
    end

    context 'with missing profile attributes' do
      let(:no_profile_params) { valid_params.deep_merge(employee: { profile_attributes: nil }) }

      it 'creates employee without profile' do
        expect {
          post :create, params: no_profile_params
        }.to change(Employee, :count).by(1)
      end
    end
  end

  describe 'PUT #update' do
    let(:update_params) do
      {
        id: employee.id,
        employee: {
          full_name: 'Updated Name',
          salary: 55000,
          profile_attributes: {
            phone_number: '+1987654321'
          }
        }
      }
    end

    before { employee }

    context 'with valid parameters' do
      it 'updates the employee' do
        put :update, params: update_params
        employee.reload
        expect(employee.full_name).to eq('Updated Name')
        expect(employee.salary).to eq(55000)
      end

      it 'updates the profile' do
        put :update, params: update_params
        employee.profile.reload
        expect(employee.profile.phone_number).to eq('+1987654321')
      end

      it 'returns ok status' do
        put :update, params: update_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { update_params.merge(employee: update_params[:employee].merge(salary: -1000)) }

      it 'does not update employee' do
        original_salary = employee.salary
        put :update, params: invalid_params
        employee.reload
        expect(employee.salary).to eq(original_salary)
      end

      it 'returns unprocessable_entity status' do
        put :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'updating employee from other company' do
      it 'returns not found' do
        put :update, params: { id: other_employee.id, employee: { full_name: 'Hacked' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the employee' do
      employee # ensure it exists
      expect {
        delete :destroy, params: { id: employee.id }
      }.to change(Employee, :count).by(-1)
    end

    it 'returns ok status' do
      delete :destroy, params: { id: employee.id }
      expect(response).to have_http_status(:ok)
    end

    context 'deleting employee from other company' do
      it 'returns not found' do
        delete :destroy, params: { id: other_employee.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'deleting non-existent employee' do
      it 'returns not found' do
        delete :destroy, params: { id: 99999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end