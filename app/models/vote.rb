class Vote < ApplicationRecord
  belongs_to :option
  belongs_to :group, optional: true
end
