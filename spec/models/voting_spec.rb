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

  describe 'automatic transition to finished status' do
    RSpec.shared_examples 'do not spawn job' do
      it 'the job is not scheduled' do
        expect(VotingTimeoutUpdater).not_to receive(:perform_in)

        voting.open!
      end
    end

    context 'when the timeout is configured' do
      let(:voting) { create :voting, status: :ready, timeout_in_seconds: 60 }
      it 'schedules a job to update the status' do
        expect(VotingTimeoutUpdater).to receive(:perform_in).with(60.seconds, voting.id)

        voting.open!
      end
    end

    context 'when the timeout is zero' do
      let(:voting) { create :voting, status: :ready, timeout_in_seconds: 0 }
      include_examples 'do not spawn job'
    end

    context 'when the timeout is not configured' do
      let(:voting) { create :voting, status: :ready, timeout_in_seconds: nil }
      include_examples 'do not spawn job'
    end
  end
end
