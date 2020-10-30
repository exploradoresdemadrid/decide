# frozen_string_literal: true

class Group < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization
  has_many :votes
  has_many :bodies_groups, dependent: :destroy
  accepts_nested_attributes_for :bodies_groups

  # Validations
  validates_presence_of :name, :available_votes
  validates_uniqueness_of :name
  validates_numericality_of :available_votes, greater_than_or_equal_to: 1
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t('activerecord.errors.email.invalid_format') },
            uniqueness: { case_sensitive: false },
            allow_blank: true
  # Callbacks
  before_validation :create_user
  after_create :create_bodies_groups

  delegate :auth_token, :auth_token_expires_at, to: :user

  def voted?(voting)
    in? voting.groups
  end

  def full_name
    [name, number].join ' '
  end

  def votes_in_body(body)
    bodies_groups.find_by(body: body).votes
  end

  private

  def create_user
    self.user_id ||= User.create!(
      email: "test+#{SecureRandom.uuid}@example.com",
      password: SecureRandom.uuid,
      organization: organization
    ).id
  end

  def create_bodies_groups
    organization.reload.bodies.each do |b|
      bodies_groups.create!(body: b, votes: b.default_votes)
    end
  end
end
