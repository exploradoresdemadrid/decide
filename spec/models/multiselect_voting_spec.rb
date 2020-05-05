# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MultiselectVoting, type: :model do
  describe 'validations' do
    subject { build :multiselect_voting }

    describe 'max_options' do
      it { should validate_numericality_of(:max_options).only_integer.is_greater_than_or_equal_to(0) }
    end
  end
end
