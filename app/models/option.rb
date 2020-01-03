class Option < ApplicationRecord
  belongs_to :question
  has_many :votes
  has_many :groups, through: :votes

  validates_presence_of :title
end
