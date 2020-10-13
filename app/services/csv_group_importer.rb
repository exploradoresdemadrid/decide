# frozen_string_literal: true

require 'csv'

class CsvGroupImporter
  def initialize(organization, raw_csv)
    @organization = organization
    @csv = CSV.parse(raw_csv, headers: true, converters: :integer)
  end

  def import!
    Group.transaction do
      @csv.map do |row|
        Group.find_or_initialize_by(organization: @organization, name: row['name'])
             .update(available_votes: row['votes'])
      end
    end
  end
end
