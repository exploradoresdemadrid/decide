class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :options

  def options
    ActiveModelSerializers::SerializableResource.new(object.options)
  end
end
