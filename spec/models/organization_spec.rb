require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    subject { build :organization }

    describe 'title' do
      it { should validate_presence_of(:name) }
    end
  end
end
