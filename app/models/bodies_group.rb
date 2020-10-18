class BodiesGroup < ApplicationRecord
  # Associations
  belongs_to :body
  belongs_to :group
end
