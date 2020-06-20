# frozen_string_literal: true

class Group < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization
  has_many :votes

  # Validations
  validates_presence_of :name, :available_votes
  validates_uniqueness_of :name
  validates_numericality_of :available_votes, greater_than_or_equal_to: 1

  before_validation :create_user

  def voted?(voting)
    in? voting.groups
  end

  def full_name
    [name, number].join ' '
  end

  private

  def create_user
    self.user_id ||= User.create!(
      email: "test+#{SecureRandom.uuid}@example.com",
      password: SecureRandom.uuid,
      organization: organization
    ).id
  end
end
