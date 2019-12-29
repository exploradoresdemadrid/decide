# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VoteSubmissionService, type: :service do
  let(:group) { create :group, available_votes: 2 }
  let(:voting) { create :voting }
  let(:question) { create :question, voting: voting }
  let(:option_1) { create :option, question: question }
  let(:option_2) { create :option, question: question }

  let(:another_voting) { create :voting }
  let(:another_question) { create :question, voting: another_voting }
  let(:another_option_1) { create :option, question: another_question }

  describe '#vote!' do
    RSpec.shared_examples 'raises an error' do |message|
      it 'raises an error' do
        expect { subject.vote! }.to raise_error(Errors::VotingError, message)
      end

      it 'does not create any vote record' do
        expect { subject.vote! rescue nil }.not_to change { Vote.count }
      end
      it 'does not create any vote submission record' do
        expect { subject.vote! rescue nil }.not_to change { VoteSubmission.count }
      end
    end

    context 'when the number of options matches the votes available' do
      subject { described_class.new(group, voting, [option_1.id, option_1.id]) }

      it 'creates several vote records' do
        expect { subject.vote! }.to change { Vote.where(option_id: option_1).count }.by(2)
      end

      it 'creates a single vote submission record associated to the group & voting' do
        subject.vote!

        submission = VoteSubmission.find_by(group_id: group.id, voting_id: voting.id)
        expect(submission.votes_submitted).to eq 2
      end
    end

    context 'when the number of options does not match the votes available' do
      subject { described_class.new(group, voting, [option_1.id, option_1.id, option_1.id]) }

      include_examples 'raises an error', 'Number of votes submitted does not match available votes: 2'
    end

    context 'when the group has already voted' do
      subject { described_class.new(group, voting, [option_1.id, option_2.id]) }
      before { subject.vote! }

      include_examples 'raises an error', 'The group has already voted'
    end

    context 'when one of the options does not belong to the selected voting' do
      subject { described_class.new(group, voting, [option_1.id, another_option_1.id]) }

      include_examples 'raises an error', 'One of the options does not belong to the voting provided'
    end

    context 'when one of the options cannot be found' do
      subject { described_class.new(group, voting, [option_1.id, SecureRandom.uuid]) }

      include_examples 'raises an error', 'One of the options could not be found'
    end

    context 'when one of the option_ids is not a UUID' do
      subject { described_class.new(group, voting, [option_1.id, 'foobar']) }

      include_examples 'raises an error', 'One of the options could not be found'
    end

    [:draft, :finished].each do |status|
      subject { described_class.new(group, voting, [option_1.id, option_2.id]) }

      context "when voting is in #{status} status" do
        before { voting.update! status: status }

        include_examples 'raises an error', "Cannot submit votes for a voting in #{status} status"
      end
    end

    context 'when group is not provided' do
      subject { described_class.new(nil, voting, [option_1.id, option_2.id]) }

      include_examples 'raises an error', 'The group was not provided'
    end
  end
end
