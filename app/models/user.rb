# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  AUTH_TOKEN_LENGTH = 6

  before_create :assign_auth_token

  private

  def assign_auth_token
    self.auth_token = AUTH_TOKEN_LENGTH.times.map { (0..9).to_a.sample.to_s }.join
  end
end
