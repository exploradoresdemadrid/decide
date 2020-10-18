require 'rails_helper'

RSpec.describe Body, type: :model do
  describe 'validations' do
    subject { build :body }

    it { should belong_to(:organization) }

    describe 'name' do
      it { should validate_presence_of(:name) }
    end

    describe 'default_votes' do
      it { should validate_presence_of(:default_votes) }
      it { should validate_numericality_of(:default_votes).is_greater_than_or_equal_to(1) }
    end
  end
end
