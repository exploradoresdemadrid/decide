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

  def question_results_table(question)
    bootstrap_table do |table|
       table.headers = ['Option', 'Votes']
       table.rows = vote_distribution_query(question).to_a
     end
  end

  def question_column_chart(question)
    column_chart vote_distribution_query(question), download: true
  end

  private

  def vote_distribution_query(question)
    Option.left_outer_joins(:votes).where(question_id: question.id).group(:title).count('votes.id')
  end
end
