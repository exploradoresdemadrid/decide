module QuestionsHelper
  def options_list(question)
    if question.options.any?
      content_tag(:ol) do
        question.options.map do |option|
          content_tag(:li) { option.title }
        end.inject(:+)
      end
    else
      alert_box context: :warning do
        'No options have been specified'
      end
    end
  end
end
