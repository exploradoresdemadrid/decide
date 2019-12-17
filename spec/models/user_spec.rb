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
  end
end
