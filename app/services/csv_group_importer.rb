# frozen_string_literal: true

require 'csv'

class CsvGroupImporter
  class CSVParseError < StandardError; end

  def initialize(organization, raw_csv)
    @organization = organization
    @csv = CSV.parse(raw_csv, headers: true, converters: :integer)
  end

  def import!
    validate!
    row_number = 0

    ActiveRecord::Base.transaction do
      @csv.each_with_index.map do |row, j|
        row_number = j + 1
        group = Group.find_or_initialize_by(organization: @organization, id: row[0])
        group.update!(name: row[1], number: row[2], email: row[3], available_votes: 1)

        body_names.each_with_index do |body_name, i|
          group.assign_votes_to_body_by_name(
            body_name,
            row[CsvGroupExporter::COMMON_HEADERS.size + i]
          )
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    raise CSVParseError, "Row #{row_number}: #{e.message}"
  end

  private

  def validate!
    raise CSVParseError, 'Formato del CSV incorrecto' unless valid_headers?
    raise CSVParseError, 'El CSV no puede contener líneas en blanco' if @csv.any? { |line| line.to_h.values.none? }
  end

  def valid_headers?
    return false unless @csv.headers.first(CsvGroupExporter::COMMON_HEADERS.size) == CsvGroupExporter::COMMON_HEADERS

    @organization.bodies.pluck(:name).sort == body_names.sort
  end

  def body_names
    (@csv.headers - CsvGroupExporter::COMMON_HEADERS).map { |header| header.gsub('Votes in ', '') }
  end
end
