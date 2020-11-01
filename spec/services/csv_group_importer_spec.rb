# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvGroupImporter, type: :service do
  describe '#import' do
  let(:organization) do
    org = create :organization
    org.bodies.destroy_all
    ['A', 'B'].each { |letter| create :body, organization: org, name: "Body #{letter}" }
    org
  end
  let(:service) { described_class.new(organization, csv_content) }

    RSpec.shared_examples 'error' do |message|
      it { expect { service.import! }.to raise_error CsvGroupImporter::CSVParseError, message }
    end

    context 'when a valid CSV is provided' do
      let(:csv_content) { File.open('spec/fixtures/groups/valid_import.csv').read }

      it 'creates as many groups as indicated' do
        expect { service.import! }.to change { Group.count }.by(3)
      end

      it 'creates the groups with the expected group information' do
        service.import!

        expect(Group.find_by(name: 'Group 1', number: 1).email).to eq 'foo+1@bar.com'
        expect(Group.find_by(name: 'Group 2', number: 2).email).to eq 'foo+2@bar.com'
        expect(Group.find_by(name: 'Group 3', number: 3).email).to eq 'foo+3@bar.com'
      end

      it 'assigns the expected votes to each decision-making body' do
        body_a = organization.bodies.find_by(name: 'Body A')
        body_b = organization.bodies.find_by(name: 'Body B')

        service.import!

        expect(Group.find_by(name: 'Group 1').votes_in_body(body_a)).to eq 1
        expect(Group.find_by(name: 'Group 1').votes_in_body(body_b)).to eq 2

        expect(Group.find_by(name: 'Group 2').votes_in_body(body_a)).to eq 3
        expect(Group.find_by(name: 'Group 2').votes_in_body(body_b)).to eq 4

        expect(Group.find_by(name: 'Group 3').votes_in_body(body_a)).to eq 5
        expect(Group.find_by(name: 'Group 3').votes_in_body(body_b)).to eq 6
      end

      it 'overrides groups found by id' do
        group = Group.create(id: '92613895-026b-42e2-b08f-b1193e4b8e18', name: 'Group Z', number: 9, email: 'old@bar.com', organization: organization)
        service.import!

        group.reload

        expect(group.name).to eq 'Group 1'
        expect(group.email).to eq 'foo+1@bar.com'
        expect(group.number).to eq 1
      end
    end
    context 'when a group does not have an associated id' do
      let(:csv_content) { File.open('spec/fixtures/groups/valid_import_create.csv').read }

      it 'creates a new group' do
        expect { service.import! }.to change { Group.count }.by(1)
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
      include_examples 'error', 'Validation failed: Votes must be greater than or equal to 0'
    end
  end
end
