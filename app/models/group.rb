class Group < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :votes

  # Validations
  validates_presence_of :name, :number, :available_votes
  validates_uniqueness_of :name, :number
  validates_numericality_of :number, :available_votes, greater_than_or_equal_to: 1

  before_validation :create_user
  private

  def create_user
    self.user_id ||= User.create(email: "test+#{number}@example.com", password: SecureRandom.uuid).id
  end
end
