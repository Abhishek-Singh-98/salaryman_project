require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { create(:profile) }

  describe 'associations' do
    it { should belong_to(:employee) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      expect(profile).to have_attributes(
        email: "john.doe@example.com",
        phone_number: "+1234567890",
        date_of_birth: Date.parse("1990-01-01"),
        joining_date: Date.parse("2020-01-01")
      )
    end
  end

  describe 'edge cases' do
    context 'with duplicate email' do
      let!(:existing_profile) { create(:profile, email: "unique@example.com") }

      it 'allows duplicate emails' do
        duplicate = build(:profile, email: "unique@example.com")
        expect(duplicate).to be_valid
      end
    end

    context 'invalid without phone_number' do
      it 'is invalid without phone_number' do
        profile = build(:profile, phone_number: nil)
        expect(profile).not_to be_valid
      end
    end

    context 'without date_of_birth' do
      it 'is valid without date_of_birth' do
        profile = build(:profile, date_of_birth: nil)
        expect(profile).to be_valid
      end
    end

    context 'with future joining_date' do
      it 'is valid with future joining_date' do
        future_date = 1.year.from_now
        profile = build(:profile, joining_date: future_date)
        expect(profile).to be_valid
      end
    end

    context 'with invalid email format' do
      it 'is invalid with invalid email' do
        profile = build(:profile, email: "invalid-email")
        expect(profile).not_to be_valid
      end
    end

    context 'with very long email' do
      it 'is valid with long email' do
        long_email = "a" * 245 + "@example.com"
        profile = build(:profile, email: long_email)
        expect(profile).to be_valid
      end
    end
  end
end