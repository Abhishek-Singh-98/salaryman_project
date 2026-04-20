require 'rails_helper'

RSpec.describe Company, type: :model do
  let!(:company) { create(:company) }

  describe 'associations' do
    it { should belong_to(:country) }
    it { should have_many(:employees) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email_domain) }
    it { should validate_presence_of(:company_code) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:email_domain) }
    it { should validate_uniqueness_of(:company_code) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      expect(company).to have_attributes(
        name: company.name,
        email_domain: company.email_domain,
        address: company.address,
        phone_number: company.phone_number
      )
      expect(company.company_code).to be_present
      expect(company.company_code).to include(company.name[0..3].upcase)
    end
  end

  describe 'edge cases' do
    context 'with duplicate name' do
      let(:company2) do
        create(:company, name: 'NewCompany', country: create(:country))
      end

      it 'is invalid with duplicate name' do
        duplicate = build(:company, name: company2.name, country: company2.country)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("has already been taken")
      end
    end

    context 'with duplicate company_code' do
      it 'is invalid with duplicate company_code' do
        duplicate = build(:company, company_code: company.company_code)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:company_code]).to include("has already been taken")
      end
    end

    context 'without country' do
      it 'is invalid without country' do
        company = build(:company, country: nil)
        expect(company).not_to be_valid
      end
    end

    context 'with special characters in name' do
      it 'is valid with special characters' do
        company = build(:company, name: "Tech-Corp & Co.")
        expect(company).to be_valid
      end
    end
  end
end