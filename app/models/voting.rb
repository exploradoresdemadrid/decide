# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: %i[draft open finished]

  has_many :questions, dependent: :destroy
  has_many :vote_submissions, dependent: :destroy
  has_many :groups, through: :vote_submissions

  validates_presence_of :title, :status

  def self.types
    [SimpleVoting, MultiselectVoting]
  end
end
