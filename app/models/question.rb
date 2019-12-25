class Question < ApplicationRecord
  belongs_to :voting
  has_many :options
  accepts_nested_attributes_for :options,  reject_if: :all_blank, allow_destroy: true

  validates_presence_of :title
end
