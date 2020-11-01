# frozen_string_literal: true

require 'csv'

class CsvGroupExporter
  BODIES_ORDER = { 'bodies.name' => 'asc' }.freeze
  GROUPS_ORDER = { 'groups.number' => :asc, 'groups.name' => :asc }.freeze
  def initialize(organization)
    @organization = organization
  end

  def export!
    @data = @organization.bodies_groups
                         .joins(:body)
                         .order(**GROUPS_ORDER, **BODIES_ORDER)
                         .pluck(:group_id, :votes)
                         .group_by(&:first)
    CSV.generate do |csv|
      csv << headers
      @organization.groups.order(number: :asc, name: :asc).each { |g| csv << build_row(g) }
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
      *@data[group.id].map(&:last)
    ]
  end

  def bodies
    @organization.bodies.order(BODIES_ORDER)
  end
end
