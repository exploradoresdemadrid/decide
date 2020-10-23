# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }

    describe 'title' do
      it { should validate_presence_of(:email) }
    end
  end

  describe 'auth_token' do
    it 'is generated on creation' do
      expect(create(:user).auth_token).not_to be_empty
    end

    it 'contains 6 digits' do
      expect(create(:user).auth_token).to match(/^\d{6}$/)
    end

    it 'expires after 7 days' do
      user = create :user
      expect(user.auth_token_expires_at).to be_between(
        (Time.now.utc + 7.days - 1.second),
        (Time.now.utc + 7.days + 1.second)
      )
    end
  end
end
