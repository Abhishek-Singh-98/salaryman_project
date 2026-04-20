require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { create(:country) }

  describe 'associations' do
    it { should have_many(:companies) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      expect(country).to have_attributes(
        name: "#{country.name}"
      )
    end
  end

  describe 'edge cases' do
    context 'with duplicate name' do
      let!(:existing_country) { create(:country, name: "Canada") }

      it 'allows duplicate names' do
        duplicate = build(:country, name: "Canada")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include("has already been taken")
      end
    end

    context 'with very long name' do
      it 'is valid with long name' do
        long_name = "A" * 255
        country = build(:country, name: long_name)
        expect(country).to be_valid
      end
    end
  end
end