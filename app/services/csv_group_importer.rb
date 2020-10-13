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

    Group.transaction do
      @csv.map do |row|
        Group.find_or_initialize_by(organization: @organization, name: row['name'])
             .update!(available_votes: row['votes'])
      end
    end
    
  rescue ActiveRecord::RecordInvalid => e
    raise CSVParseError, e.message
  end

  private

  def validate!
    raise CSVParseError, 'Formato del CSV incorrecto' unless @csv.headers == %w[name votes]
    raise CSVParseError, 'El CSV no puede contener líneas en blanco' if @csv.any? { |line| line.to_h.values.none? }
  end
end
