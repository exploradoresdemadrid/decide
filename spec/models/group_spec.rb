# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    subject { build :group }
    describe 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    describe 'available votes' do
      it { should validate_presence_of(:available_votes) }
      it { should validate_numericality_of(:available_votes).is_greater_than_or_equal_to(1) }
    end

    describe 'email' do
      it { should validate_uniqueness_of(:email).allow_nil.case_insensitive }
      it { expect(build(:group, email: 'foo@bar@bar.com')).not_to be_valid }
      it { expect(build(:group, email: 'foo@bar.com')).to be_valid }
    end
  end

  describe 'callbacks' do
    context 'when a group is created' do
      it 'creates and assigns a user to the group' do
        expect(create(:group).user).to be_a(User)
      end

      it 'the email of the fake user contains is made with a UUID' do
        uuid_regex = '[0-9A-F]{8}-[0-9A-F]{4}-[4][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}'
        expect(create(:group).user.email).to match(/^test\+#{uuid_regex}@example.com$/i)
      end

      it 'creates a record per body with the default votes' do
        organization = create :organization
        organization.bodies.destroy_all
        create :body, organization: organization, default_votes: 1
        create :body, organization: organization, default_votes: 3
        create :body, organization: organization, default_votes: 5

        group = create :group, organization: organization
        expect(group.bodies_groups.pluck(:votes)).to contain_exactly(1, 3, 5)
      end
    end
  end
end
