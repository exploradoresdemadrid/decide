require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    subject { build :question }

    describe 'title' do
      it { should validate_presence_of(:title) }
    end
  end

  describe '#misconfigured?' do
    let(:question) { create :question, voting: create(:voting) }

    context 'when the question has no options' do
      before { question.options.destroy_all }
      it { expect(question).to be_misconfigured }
    end

    context 'when the question has just one option' do
      before { question.options.create(title: :foo) }
      it { expect(question).to be_misconfigured }
    end

    context 'when the question has no options' do
      before { 2.times{ |i| question.options.create(title: "Option #{i}") } }
      it { expect(question).not_to be_misconfigured }
    end
  end
end
