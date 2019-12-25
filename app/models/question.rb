class Question < ApplicationRecord
  belongs_to :voting
  has_many :options

  validates_presence_of :title
end
