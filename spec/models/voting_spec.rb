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

    describe 'timeout_in_seconds' do
      it { should validate_numericality_of(:timeout_in_seconds).only_integer.is_greater_than_or_equal_to(0).allow_nil }
    end
  end
end
