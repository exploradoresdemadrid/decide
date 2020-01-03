# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: %i[draft open finished]

  has_many :questions
  has_many :vote_submissions
  has_many :groups, through: :vote_submissions

  validates_presence_of :title, :status
end
