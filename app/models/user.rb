# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :trackable

  AUTH_TOKEN_LENGTH = 6
  AUTH_TOKEN_EXPIRATION_IN_DAYS = 7

  scope :with_valid_auth_token, -> { where('auth_token_expires_at > ?', Time.current) }
  scope :with_group, -> { joins(:group) }

  before_create :assign_auth_token

  has_one :group

  def reset_token
    assign_auth_token
    save!
  end

  def admin?
    group.nil?
  end

  def superadmin?
    true
  end

  private

  def assign_auth_token
    self.auth_token = AUTH_TOKEN_LENGTH.times.map { (0..9).to_a.sample.to_s }.join
    self.auth_token_expires_at = Time.current + AUTH_TOKEN_EXPIRATION_IN_DAYS.days
  end
end
