# frozen_string_literal: true

require 'csv'

class CsvGroupExporter
  def initialize(organization)
    @organization = organization
  end

  def export!
    CSV.generate do |csv|
      csv << headers
      @organization.groups.each { |g| csv << build_row(g) }
    end
  end

  private

  def headers
    [
      'ID',
      'Name',
      'Number (optional)',
      'Email',
      *bodies.pluck(:name).map { |b| "Votes in #{b}" }
    ]
  end

  def build_row(group)
    [
      group.id,
      group.name,
      group.number,
      group.email,
      *bodies.map { |b| group.votes_in_body(b) }
    ]
  end

  def bodies
    @organization.bodies.order(name: :asc)
  end
end
