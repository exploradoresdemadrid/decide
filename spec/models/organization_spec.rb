require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    subject { build :organization }

    describe 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end
  end

  describe 'callbacks' do
    describe 'decision-making bodies' do
      let(:organization) { create :organization, name: 'Foo Organization' }

      it 'creates a default body with name of the organization' do
        expect(organization.bodies.pluck(:name)).to contain_exactly('Foo Organization')
      end

      it 'configures the default votes as 1' do
        expect(organization.bodies.first.default_votes).to eq 1
      end
    end
  end
end
