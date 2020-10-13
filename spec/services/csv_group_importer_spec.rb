# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvGroupImporter, type: :service do
  describe '#import' do
    context 'when a valid CSV is provided' do
      let(:organization) { create :organization }
      let(:service) { described_class.new(organization, csv_content) }
      let(:csv_content) { File.open('spec/fixtures/groups/valid_import.csv').read }

      it 'creates as many groups as indicated' do
        expect { service.import! }.to change { Group.count }.by(3)
      end

      it 'creates the groups with the expected information' do
        service.import!

        expect(Group.find_by(name: 'Group 1').available_votes).to eq 1
        expect(Group.find_by(name: 'Group 2').available_votes).to eq 2
        expect(Group.find_by(name: 'Group 3').available_votes).to eq 3
      end

      it 'overrides groups found by name' do
        group = Group.create(name: 'Group 1', available_votes: 4, organization: organization)
        service.import!

        expect(group.reload.available_votes).to eq 1
      end
    end
  end
end
