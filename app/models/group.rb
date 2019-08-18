class Group < ApplicationRecord
  # Validations
  validates_presence_of :name, :number, :available_votes
  validates_uniqueness_of :name, :number
  validates_numericality_of :number, :available_votes, greater_than_or_equal_to: 1
end
