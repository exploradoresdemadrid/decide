class Question < ApplicationRecord
  belongs_to :voting

  validates_presence_of :title
end
