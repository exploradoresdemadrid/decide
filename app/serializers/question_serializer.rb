class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
  has_one :voting
end
