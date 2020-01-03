class Option < ApplicationRecord
  belongs_to :question
  has_many :votes, dependent: :destroy
  has_many :groups, through: :votes

  validates_presence_of :title
end
