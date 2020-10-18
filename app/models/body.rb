class Body < ApplicationRecord
  # Associations
  belongs_to :organization

  # Validations
  validates_presence_of :name, :default_votes
  validates_numericality_of :default_votes, greater_than_or_equal_to: 1
end
