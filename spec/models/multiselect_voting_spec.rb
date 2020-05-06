# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MultiselectVoting, type: :model do
  describe 'validations' do
    subject { build :multiselect_voting }

    describe 'max_options' do
      it { should validate_numericality_of(:max_options).only_integer.allow_nil.is_greater_than_or_equal_to(0) }
    end
  end

  describe 'options' do
    subject { create(:multiselect_voting, options: "Foo\nBar") }
    it 'creates one question per option during creation' do
      expect(subject.questions.count).to eq 2
    end

    it 'the options created have Yes/No choices' do
      expect(subject.questions.first.options.pluck(:title)).to contain_exactly('Yes', 'No')
    end

    it 'creates new options during update' do
      subject.update(options: "Foo\nBar\nFoobar")
      expect(subject.questions.count).to eq 3
    end

    it 'deletes the questions that no longer apply' do
      subject.update(options: 'Foo')
      expect(subject.questions.count).to eq 1
    end

    it 'does not modify the questions that are the same after update' do
      existing_ids = subject.questions.pluck(:id)
      subject.update(options: "Foo\nBar\nFoobar")
      expect(subject.questions.pluck(:id)).to include(*existing_ids)
    end

    it 'allows creation of votings with no options' do
      expect(create(:multiselect_voting, options: nil)).to be_persisted
    end
  end

  describe '#transform_votes' do
    context 'when there are several questions' do
      subject { create(:multiselect_voting, options: "Foo\nBar") }
      let(:first_question) { subject.questions.find_by(title: 'Foo') }
      let(:second_question) { subject.questions.find_by(title: 'Bar') }
      let(:original_response) do
        {
          first_question.id => { first_question.options.yes.first.id => 4 },
          second_question.id => { second_question.options.yes.first.id => 0 }
        }
      end

      it 'leaves the selected option untouched' do
        expect(subject.transform_votes(original_response, available_votes: 4)[first_question.id]).to eq(original_response[first_question.id])
      end

      it 'defaults to the non-selected option if no value was selected' do
        expect(subject.transform_votes(original_response, available_votes: 4)[second_question.id]).to eq(second_question.options.no.first.id => 4)
      end
    end
  end

  describe '#perform_voting_validations' do
    subject { create(:multiselect_voting, options: "Foo\nBar\nFooBar\nBarFoo") }
    let(:first_question) { subject.questions.find_by(title: 'Foo') }
    let(:second_question) { subject.questions.find_by(title: 'Bar') }
    let(:third_question) { subject.questions.find_by(title: 'FooBar') }
    let(:fourth_question) { subject.questions.find_by(title: 'BarFoo') }

    context 'when max options are not configured' do
      before { subject.update(max_options: nil) }

      it 'does not raise an error' do
        expect do
          subject.perform_voting_validations!(
            first_question.id => { first_question.options.yes.first.id => 4 },
            second_question.id => { second_question.options.yes.first.id => 4 },
            third_question.id => { third_question.options.yes.first.id => 4 },
            fourth_question.id => { fourth_question.options.yes.first.id => 4 }
          )
        end.not_to raise_error
      end
    end

    context 'when max options are configured' do
      before { subject.update(max_options: 2) }

      it 'does not raise an error if selected options are under threshold' do
        expect do
          subject.perform_voting_validations!(
            first_question.id => { first_question.options.yes.first.id => 4 },
            second_question.id => { second_question.options.yes.first.id => 0 },
            third_question.id => { third_question.options.yes.first.id => 0 },
            fourth_question.id => { fourth_question.options.yes.first.id => 0 }
          )
        end.not_to raise_error
      end

      it 'does not raise an error if selected options equal the threshold' do
        expect do
          subject.perform_voting_validations!(
            first_question.id => { first_question.options.yes.first.id => 4 },
            second_question.id => { second_question.options.yes.first.id => 4 },
            third_question.id => { third_question.options.yes.first.id => 0 },
            fourth_question.id => { fourth_question.options.yes.first.id => 0 }
          )
        end.not_to raise_error
      end

      it 'raises an error if group selected more options than allowed' do
        expect do
          subject.perform_voting_validations!(
            first_question.id => { first_question.options.yes.first.id => 4 },
            second_question.id => { second_question.options.yes.first.id => 4 },
            third_question.id => { third_question.options.yes.first.id => 4 },
            fourth_question.id => { fourth_question.options.yes.first.id => 0 }
          )
        end.to raise_error Errors::VotingError, 'At most 2 options can be selected, but you chose 3'
      end
    end
  end
end
