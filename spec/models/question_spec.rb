require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    subject { build :question }

    describe 'title' do
      it { should validate_presence_of(:title) }
    end
  end
end
