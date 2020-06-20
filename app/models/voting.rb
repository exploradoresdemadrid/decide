# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: %i[draft open finished]

  belongs_to :organization
  has_many :questions, dependent: :destroy
  has_many :vote_submissions, dependent: :destroy
  has_many :groups, through: :vote_submissions

  validates_presence_of :title, :status

  scope :published, -> { where.not(status: :draft) }

  def self.human_class_name
    name.underscore.gsub('_', ' ').split.first.capitalize
  end

  def self.types
    [SimpleVoting, MultiselectVoting]
  end

  def transform_votes(votes, _options)
    votes
  end

  def perform_voting_validations!(votes); end
end
