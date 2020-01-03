# frozen_string_literal: true

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
    distribution = vote_distribution_query(question)
    votes_count = distribution.values.sum
    group_distribution = vote_distribution_by_group(question)

    bootstrap_table do |table|
      table.headers = ['Option', 'Votes', 'Percentage', 'Supporting groups']
      table.rows = distribution.map do |(option, votes)|
        [
          option,
          votes,
          "#{(votes * 100.0 / votes_count).round(2)}%",
          string_list(group_distribution[option].map { |(group_name, group_votes)| "#{group_name} (#{group_votes} votes)" })
        ]
      end
    end
  end

  def question_column_chart(question)
    column_chart vote_distribution_query(question), download: true
  end

  private

  def vote_distribution_by_group(question)
    Option.joins(:groups)
          .where(question_id: question.id)
          .group(:id, 'groups.name')
          .count
          .map { |(option_id, group_name), votes| [option_id, group_name, votes] }
          .group_by(&:first)
          .map { |option_id, groups| [Option.find(option_id).title, groups.map { |(_, name, votes)| [name, votes] }] }
          .to_h
  end

  def vote_distribution_query(question)
    Option.left_outer_joins(:votes).where(question_id: question.id).group(:title).count('votes.id')
  end
end
