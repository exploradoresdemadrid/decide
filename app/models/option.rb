class Option < ApplicationRecord
  belongs_to :question
  has_many :votes, dependent: :destroy
  has_many :groups, through: :votes

  validates_presence_of :title

  scope :yes, -> { where(title: 'Yes') }
  scope :no, -> { where(title: 'No') }
end
