# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvGroupImporter, type: :service do
  describe '#import' do
  let(:organization) { create :organization }
  let(:service) { described_class.new(organization, csv_content) }

    RSpec.shared_examples 'error' do |message|
      it { expect { service.import! }.to raise_error CsvGroupImporter::CSVParseError, message }
    end

    context 'when a valid CSV is provided' do
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

    context 'when a CSV with more columns is provided' do
      let(:csv_content) { File.open('spec/fixtures/groups/invalid_extra_columns.csv').read }
      include_examples 'error', 'Formato del CSV incorrecto'
    end

    context 'when there is an empty line' do
      let(:csv_content) { File.open('spec/fixtures/groups/invalid_empty_line.csv').read }
      include_examples 'error', 'El CSV no puede contener líneas en blanco'
    end

    context 'when the header is missing' do
      let(:csv_content) { File.open('spec/fixtures/groups/invalid_no_header.csv').read }
      include_examples 'error', 'Formato del CSV incorrecto'
    end

    context 'when group validations do not pass' do
      let(:csv_content) { File.open('spec/fixtures/groups/invalid_wrong_information.csv').read }
      include_examples 'error', 'Validation failed: Available votes must be greater than or equal to 1'
    end
  end
end
