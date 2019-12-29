# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    subject { build :group }
    describe 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    describe 'number' do
      it { should validate_presence_of(:number) }
      it { should validate_uniqueness_of(:number) }
      it { should validate_numericality_of(:number).is_greater_than_or_equal_to(1) }
    end

    describe 'available votes' do
      it { should validate_presence_of(:available_votes) }
      it { should validate_numericality_of(:available_votes).is_greater_than_or_equal_to(1) }
    end
  end

  describe 'callbacks' do
    context 'when a group is created' do
      it 'creates and assigns a user to the group' do
        expect(create(:group).user).to be_a(User)
      end
    end
  end
end
