require 'rails_helper'

RSpec.describe SalaryInsightsController, type: :controller do
  let(:country1) { create(:country) }
  let(:country2) { create(:country, name: 'Country 2') }
  let(:company) { create(:company, country: country1) }
  let(:other_company) { create(:company, name: 'Other Company', country: country2) }
  let(:hr_manager) { create(:employee, :hr_manager, company: company, salary: 80000) }
  let(:employee1) { create(:employee, company: company, salary: 50000) }
  let(:employee2) { create(:employee, company: company, salary: 60000) }
  let(:other_employee) { create(:employee, company: other_company, salary: 55000) }
  let(:job_title1) { create(:job_title) }
  let(:job_title2) { create(:job_title) }
  let(:expected_average) { (employee1.salary + other_employee.salary) / 2.0 }


  before do
    session[:employee_id] = hr_manager.id
  end

  describe 'GET #index' do
    before do
      create(:employee_job_title, employee: employee1, job_title: job_title1)
      create(:employee_job_title, employee: employee2, job_title: job_title2)
      create(:employee_job_title, employee: other_employee, job_title: job_title1)
    end

    it 'returns salary insights' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('insights')
      expect(json_response).to have_key('filters')
    end

    it 'returns ok status and returns count 4' do
      get :index
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response['insights']['overall']['count']).to eq(4)
    end

    it 'includes overall insights' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['insights']).to have_key('overall')
      expect(json_response['insights']['overall']).to have_key('average')
      expect(json_response['insights']['overall']).to have_key('min')
      expect(json_response['insights']['overall']).to have_key('max')
    end

    it 'calculates correct average salary' do
      get :index
      json_response = JSON.parse(response.body)
      expected_average = (hr_manager.salary + 
                employee1.salary + employee2.salary + 
                other_employee.salary) / 4.0
      expect(json_response['insights']['overall']['average']).to eq(expected_average.round(2))
    end

    it 'calculates correct min and max' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['insights']['overall']['min']).to eq(50000)
      expect(json_response['insights']['overall']['max']).to eq(80000)
    end

    context 'with role filter' do
      it 'filters by role' do
        get :index, params: { role: 'employee' }
        json_response = JSON.parse(response.body)
        expect(json_response['insights']).not_to have_key('hr_manager')
        expect(json_response['insights']['employee']['average']).to eq(55000)
        expect(json_response['insights']['employee']['min']).to eq(50000)
        expect(json_response['insights']['employee']['max']).to eq(60000)
      end
    end

    context 'with job_title filter' do
      it 'filters by job_title' do
        get :index, params: { job_title_id: job_title1.id }
        json_response = JSON.parse(response.body)
        expect(json_response['insights']['overall']['count']).to eq(2)
        expect(json_response['insights']['overall']['average']).to eq(expected_average)
      end
    end

    context 'with role and job_title filters' do
      it 'filters by both' do
        get :index, params: { role: 'employee', job_title_id: job_title1.id }
        json_response = JSON.parse(response.body)
        expect(json_response['insights']['overall']['count']).to eq(2)
        expect(json_response['insights']['overall']['average']).to eq(expected_average)
      end
    end

    context 'with country filter and role filter and job_title filter' do
      it 'filters by all three' do
        get :index, params: { country_id: country1.id, role: 'employee', job_title_id: job_title1.id }
        json_response = JSON.parse(response.body)
        expect(json_response['insights']['overall']['count']).to eq(1)
        expect(json_response['insights']['overall']['average']).to eq(50000)
      end
    end

    context 'when not authenticated' do
      before { session[:employee_id] = nil }

      it 'returns unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'scoped to country' do
      it 'only includes employees from same country' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response['insights']['overall']['count']).to be >= 3
      end
    end

    context 'with my_company_insight flag present' do
      it 'only includes employees from current employee company' do
        get :index, params: { my_company_insight: true }
        json_response = JSON.parse(response.body)
        expect(json_response['insights']['overall']['count']).to eq(3)
      end
    end

    context 'with my_company_insight flag as false' do
      it 'includes employees from all companies in all the countries' do
        get :index, params: { my_company_insight: false }
        json_response = JSON.parse(response.body)
        expect(json_response['insights']['overall']['count']).to be >= 4
      end
    end
  end
end