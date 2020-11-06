# frozen_string_literal: true

class Organization < ApplicationRecord
  SMOKETEST_CODE = 'decide_edm_smoketest'

  has_many :users, dependent: :destroy
  has_many :votings, dependent: :destroy
  has_many :groups, through: :users
  has_many :bodies, dependent: :destroy
  has_many :bodies_groups, through: :groups

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create :create_default_body
  after_create :create_admin_account

  attr_accessor :admin_email, :admin_password

  def smoke_test?
    name.include? SMOKETEST_CODE
  end

  private

  def create_default_body
    bodies.create!(name: name, default_votes: 1)
  end

  def create_admin_account
    users.create!(email: admin_email, role: :admin, password: admin_password) if admin_email && admin_password
  end
end
