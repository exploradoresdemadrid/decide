class Body < ApplicationRecord
  # Associations
  belongs_to :organization
  has_many :bodies_groups
  has_many :votings
  has_and_belongs_to_many :groups

  # Validations
  validates_presence_of :name, :default_votes
  validates_numericality_of :default_votes, greater_than_or_equal_to: 1

  # Callbacks
  after_create :create_bodies_groups

  private

  def create_bodies_groups
    organization.reload.groups.each do |g|
      bodies_groups.create!(group: g, votes: default_votes)
    end
  end
end
