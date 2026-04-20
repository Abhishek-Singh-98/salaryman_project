require 'rails_helper'

RSpec.describe JobTitle, type: :model do
  let(:job_title) { create(:job_title) }

  describe 'associations' do
    it { should have_many(:employee_job_titles) }
    it { should have_many(:employees).through(:employee_job_titles) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'enums' do
    it { should define_enum_for(:department).with_values([:engineering, :hr, :sales, :marketing, :finance]) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      expect(job_title).to have_attributes(
        title: "Software Engineer",
        description: "Develops software applications",
        department: "engineering",
        abbreviation: "SWE"
      )
    end
  end

  describe 'edge cases' do
    context 'with duplicate title' do
      let!(:existing_job_title) { create(:job_title, title: "Manager") }

      it 'allows duplicate titles' do
        duplicate = build(:job_title, title: "Manager")
        expect(duplicate).to be_valid
      end
    end

    context 'without description' do
      it 'is valid without description' do
        job_title = build(:job_title, description: nil)
        expect(job_title).to be_valid
      end
    end

    context 'with long description' do
      it 'is valid with long description' do
        long_desc = "A" * 1000
        job_title = build(:job_title, description: long_desc)
        expect(job_title).to be_valid
      end
    end

    context 'with invalid department' do
      it 'is invalid with invalid department' do
        expect {
          create(:job_title, department: 7)
        }.to raise_error(ArgumentError)
      end
    end
  end
end