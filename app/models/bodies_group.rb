class BodiesGroup < ApplicationRecord
  # Associations
  belongs_to :body
  belongs_to :group

  validates_numericality_of :votes, greater_than_or_equal_to: 0
end
