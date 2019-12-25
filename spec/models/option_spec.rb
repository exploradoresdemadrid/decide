require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'validations' do
    subject { build :option }

    describe 'title' do
      it { should validate_presence_of(:title) }
    end
  end
end
