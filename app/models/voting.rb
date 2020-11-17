# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: {
    draft: 0,
    ready: 3,
    open: 1,
    finished: 2,
    archived: 4
  }

  # Associations
  belongs_to :organization
  belongs_to :body
  has_many :questions, dependent: :destroy
  has_many :vote_submissions, dependent: :destroy
  has_many :groups, through: :vote_submissions

  # Validations
  validates_presence_of :title, :status
  validates_numericality_of :timeout_in_seconds, only_integer: true, greater_than_or_equal_to: 0, allow_nil: true

  scope :published, -> { where.not(status: :draft) }

  before_save :spawn_timeout_worker
  before_validation :assign_default_body

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

  def misconfigured?
    return true if questions.none?
    questions.any?(&:misconfigured?)
  end

  private

  def spawn_timeout_worker
    self.finishes_at = nil
    return if timeout_in_seconds.to_i.zero?
    return unless status_changed?(from: 'ready', to: 'open') || status_changed?(from: 'draft', to: 'open')

    VotingTimeoutUpdater.perform_in(timeout_in_seconds.seconds, id)
    self.finishes_at = timeout_in_seconds.seconds.from_now
  end

  def assign_default_body
    self.body = organization.bodies.first if body.nil? && organization.bodies.count == 1
  end
end
