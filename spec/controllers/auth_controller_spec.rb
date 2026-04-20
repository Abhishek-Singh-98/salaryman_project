require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:country) { create(:country) }
  let(:company) { create(:company, country: country) }
  let(:employee) { create(:employee, :with_profile, company: company) }

  describe 'POST #sign_up' do
    let(:valid_params) do
      {
        auth: {
          email: 'newuser@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          phone_number: '+1551234567',
          company_code: company.company_code,
          full_name: 'New User',
          joining_date: '2023-01-01'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new employee' do
        expect {
          post :sign_up, params: valid_params
        }.to change(Employee, :count).by(1)
      end

      it 'creates a new profile' do
        expect {
          post :sign_up, params: valid_params
        }.to change(Profile, :count).by(1)
      end

      it 'returns created status' do
        post :sign_up, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'sets session employee_id' do
        post :sign_up, params: valid_params
        expect(session[:employee_id]).to be_present
      end
    end

    context 'with invalid company code' do
      let(:invalid_params) { valid_params.merge(auth: valid_params[:auth].merge(company_code: 'INVALID')) }

      it 'does not create employee' do
        expect {
          post :sign_up, params: invalid_params
        }.not_to change(Employee, :count)
      end

      it 'returns unprocessable_entity status' do
        post :sign_up, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with password mismatch' do
      let(:mismatch_params) { valid_params.merge(auth: valid_params[:auth].merge(password_confirmation: 'different')) }

      it 'does not create employee' do
        expect {
          post :sign_up, params: mismatch_params
        }.not_to change(Employee, :count)
      end

      it 'returns unprocessable_entity status' do
        post :sign_up, params: mismatch_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with duplicate email' do
      let!(:existing_profile) { create(:profile, email: 'newuser@example.com') }
      let(:duplicate_params) { valid_params }

      it 'creates employee but profile creation fails' do
        expect {
          post :sign_up, params: duplicate_params
        }.to change(Employee, :count).by(0)
      end
    end

    context 'with missing required fields' do
      let(:incomplete_params) { { auth: { email: 'test@example.com' } } }

      it 'does not create employee' do
        expect {
          post :sign_up, params: incomplete_params
        }.not_to change(Employee, :count)
      end

      it 'returns unprocessable_entity status' do
        post :sign_up, params: incomplete_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #login' do
    let(:login_params) do
      {
        auth: {
          email: employee.profile.email,
          password: 'password123',
          company_code: company.company_code
        }
      }
    end

    before do
      employee.update(password: 'password123')
    end

    context 'with valid credentials' do
      it 'returns ok status' do
        post :login, params: login_params
        expect(response).to have_http_status(:ok)
      end

      it 'sets session employee_id' do
        post :login, params: login_params
        expect(session[:employee_id]).to eq(employee.id)
      end

      it 'returns employee data' do
        post :login, params: login_params
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(employee.id)
      end
    end

    context 'with invalid email' do
      let(:invalid_email_params) { login_params.merge(auth: login_params[:auth].merge(email: 'wrong@example.com')) }

      it 'returns unprocessable_entity status' do
        post :login, params: invalid_email_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not set session' do
        post :login, params: invalid_email_params
        expect(session[:employee_id]).to be_nil
      end
    end

    context 'with wrong password' do
      let(:wrong_password_params) { login_params.merge(auth: login_params[:auth].merge(password: 'wrongpass')) }

      it 'returns unauthorized status' do
        post :login, params: wrong_password_params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid company code' do
      let(:wrong_company_params) { login_params.merge(auth: login_params[:auth].merge(company_code: 'WRONG')) }

      it 'returns unprocessable_entity status' do
        post :login, params: wrong_company_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with employee without profile' do
      let(:employee_no_profile) { create(:employee, company: company) }
      let(:no_profile_params) do
        {
          auth: {
            email: 'nonexistent@example.com',
            password: 'password123',
            company_code: company.company_code
          }
        }
      end

      it 'returns unprocessable_entity status' do
        post :login, params: no_profile_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #logout' do
    let(:hr_emp) {create(:employee, :hr_manager, company: company) }
    before { session[:employee_id] = hr_emp.id }

    it 'clears session' do
      delete :logout, params: { employee_id: hr_emp.id }
      expect(session[:employee_id]).to be_nil
    end

    it 'returns ok status' do
      delete :logout, params: { employee_id: hr_emp.id }
      expect(response).to have_http_status(:ok)
    end
  end
end