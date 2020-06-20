require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    subject { build :organization }

    describe 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end
  end
end
