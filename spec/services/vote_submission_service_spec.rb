# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VoteSubmissionService, type: :service do
  let!(:group) { create :group, available_votes: 2 }
  let!(:voting) { create :voting }
  let!(:question_1) { create :question, voting: voting }
  let!(:option_1_1) { create :option, question: question_1 }
  let!(:option_1_2) { create :option, question: question_1 }
  let!(:question_2) { create :question, voting: voting }
  let!(:option_2_1) { create :option, question: question_2 }

  let(:another_voting) { create :voting }
  let(:another_question) { create :question, voting: another_voting }
  let(:another_option_1) { create :option, question: another_question }

  describe '#vote!' do
    RSpec.shared_examples 'raises an error' do |message|
      it 'raises an error' do
        expect { subject.vote! }.to raise_error(Errors::VotingError, message)
      end

      it 'does not create any vote record' do
        expect do
          subject.vote!
        rescue StandardError
          nil
        end .not_to change { Vote.count }
      end
      it 'does not create any vote submission record' do
        expect do
          subject.vote!
        rescue StandardError
          nil
        end .not_to change { VoteSubmission.count }
      end
    end

    RSpec.shared_examples 'votes created' do
      it 'creates several vote records' do
        expect { subject.vote! }.to change { Vote.where(option_id: option_1_1).count }.by(2)
      end

      it 'creates a single vote submission record associated to the group & voting' do
        subject.vote!

        submission = VoteSubmission.find_by(group_id: group.id, voting_id: voting.id)
        expect(submission.votes_submitted).to eq 2
      end
    end

    context 'when the number of options matches the votes available' do
      subject do
        described_class.new(group, voting, question_1.id => [option_1_1.id, option_1_1.id],
                                           question_2.id => [option_2_1.id, option_2_1.id])
      end

      context 'when the voting is secret' do
        before { voting.update(secret: true) }

        include_examples 'votes created'

        it 'does not assign the group to the votes' do
          subject.vote!

          expect(Vote.where.not(group_id: nil).count).to eq 0
        end
      end

      context 'when the voting is not secret' do
        before { voting.update(secret: false) }

        include_examples 'votes created'

        it 'assigns the group to the votes' do
          subject.vote!

          expect(Vote.where(group_id: nil).count).to eq 0
        end
      end
    end

    context 'when the number of options does not match the votes available' do
      subject do
        described_class.new(group, voting, question_1.id => [option_1_1.id, option_1_1.id, option_1_1.id],
                                           question_2.id => [option_2_1.id, option_2_1.id])
      end

      include_examples 'raises an error', 'Number of votes submitted does not match available votes: 2'
    end

    context 'when the number of options does not match the votes available (multiple questions)' do
      subject do
        described_class.new(group, voting, question_1.id => [option_1_1.id, option_1_1.id, option_1_1.id],
                                           question_2.id => [option_2_1.id, option_2_1.id])
      end

      include_examples 'raises an error', 'Number of votes submitted does not match available votes: 2'
    end

    context 'when the group has already voted' do
      subject do
        described_class.new(group, voting, question_1.id => [option_1_1.id, option_1_2.id],
                                           question_2.id => [option_2_1.id, option_2_1.id])
      end
      before { subject.vote! }

      include_examples 'raises an error', 'The group has already voted'
    end

    context 'when one of the questions does not belong to the selected voting' do
      subject { described_class.new(group, voting, another_question.id => [another_option_1.id, another_option_1.id]) }

      include_examples 'raises an error', 'One of the questions does not belong to the voting provided'
    end

    context 'when one of the options does not belong to the selected question' do
      subject { described_class.new(group, voting, question_2.id => [option_1_1.id, option_1_2.id]) }

      include_examples 'raises an error', 'One of the options does not belong to the question provided'
    end

    context 'when one of the options cannot be found' do
      subject do
        described_class.new(group, voting, question_1.id => [option_1_1.id, SecureRandom.uuid],
                                           question_2.id => [option_2_1.id, option_2_1.id])
      end

      include_examples 'raises an error', 'One of the options could not be found'
    end

    context 'when one of the option_ids is not a UUID' do
      subject do
        described_class.new(group, voting, question_1.id => [option_1_1.id, 'foobar'],
                                           question_2.id => [option_2_1.id, option_2_1.id])
      end

      include_examples 'raises an error', 'One of the options could not be found'
    end

    %i[draft finished].each do |status|
      subject { described_class.new(group, voting, question_1.id => [option_1_1.id, option_1_2.id]) }

      context "when voting is in #{status} status" do
        before { voting.update! status: status }

        include_examples 'raises an error', "Cannot submit votes for a voting in #{status} status"
      end
    end

    context 'when group is not provided' do
      subject { described_class.new(nil, voting, question_1.id => [option_1_1.id, option_1_2.id]) }

      include_examples 'raises an error', 'The group was not provided'
    end

    context 'when answers for one of the questions have not been provided' do
      subject { described_class.new(group, voting, question_1.id => [option_1_1.id, option_1_1.id]) }

      include_examples 'raises an error', 'Votes for some of the questions are missing'
    end
  end
end
