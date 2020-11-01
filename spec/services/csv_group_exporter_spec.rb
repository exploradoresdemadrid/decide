# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvGroupExporter, type: :service do
  describe '#export' do
    let(:organization) { create :organization }
    let(:service) { described_class.new(organization) }
    let(:export) { CSV.parse(service.export!) }

    context 'when the organization has a single decision-making body' do
      let(:organization) { create :organization, name: 'Sample org'}
      it 'only renders one column for votes' do
        expect(export.first).to eq(["ID (do not modify)", "Name", "Number (optional)", "Email", "Votes in Sample org"])
      end
    end

    context 'when the organization has 3 decision-making bodies' do
      before do
        organization.bodies.destroy_all
        ['c', 'a', 'b'].each { |b| organization.bodies.create!(name: "Body #{b}", default_votes: 1) }
      end

      it 'renders three columns for votes, ordered alphabetically by body name' do
        expect(export.first).to eq(["ID (do not modify)", "Name", "Number (optional)", "Email", "Votes in Body a", "Votes in Body b", "Votes in Body c"])
      end
    end

    context 'when the organization has no groups' do
      it 'only renders the heades' do
        expect(export.size).to eq 1
      end
    end

    context 'when the organization has 3 groups' do
      before do
        create :group, organization: organization, name: 'Group B', number: 5, email: 'ordered3@foo.com'
        create :group, organization: organization, name: 'Group A', number: 5, email: 'ordered2@foo.com'
        create :group, organization: organization, name: 'Group C', number: 2, email: 'ordered1@foo.com'
      end
      it 'renders two rows in addition to the headers' do
        expect(export.size).to eq 4
      end

      it 'orders the groups by number, then by name' do
        expect(export.map { |row| row[3] }).to eq ['Email', 'ordered1@foo.com', 'ordered2@foo.com', 'ordered3@foo.com']
      end
    end

    describe 'group rows' do
      let(:row) { export[1] }
      before do
        organization.bodies.destroy_all
        ['A', 'B'].each { |b| organization.bodies.create!(name: "Body #{b}", default_votes: 1) }
        @group = create(:group, organization: organization, name: 'Sample Group', number: 45, email: 'foo@bar.com')
        @group.bodies_groups.joins(:body).where(bodies: { name: 'Body A' }).update(votes: 7)
        @group.bodies_groups.joins(:body).where(bodies: { name: 'Body B' }).update(votes: 8)
      end
      context 'when all information is available' do
        it('renders group id') { expect(row[0].length).to eq 36 }
        it('renders group name') { expect(row[1]).to eq 'Sample Group' }
        it('renders group number') { expect(row[2]).to eq '45' }
        it('renders group email') { expect(row[3]).to eq 'foo@bar.com' }
        it('renders votes in Body A') { expect(row[4]).to eq '7' }
        it('renders votes in Body B') { expect(row[5]).to eq '8' }
      end
    end
  end
end
