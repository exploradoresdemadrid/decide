class Question < ApplicationRecord
  belongs_to :voting
  has_many :options, dependent: :destroy
  has_many :votes, through: :options
  default_scope { order(title: :asc) }

  accepts_nested_attributes_for :options, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :title

  delegate :body, to: :voting

  def misconfigured?
    options.count < 2
  end
end
