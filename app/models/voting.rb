# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: %i[draft open finished]

  validates_presence_of :title, :status
end
