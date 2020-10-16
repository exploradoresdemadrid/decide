# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting, type: :model do
  describe 'validations' do
    subject { build :voting }

    describe 'title' do
      it { should validate_presence_of(:title) }
    end

    describe 'status' do
      it { should validate_presence_of(:status) }
      it { should define_enum_for(:status).with_values(%i[draft open finished ready archived]) }
    end
  end
end
