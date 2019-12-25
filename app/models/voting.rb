# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: %i[draft open finished]

  has_many :questions

  validates_presence_of :title, :status
end
