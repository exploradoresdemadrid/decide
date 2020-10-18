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
        t('options.none')
      end
    end
  end

  def question_results_table(question)
    distribution = vote_distribution_query(question)
    votes_count = distribution.values.sum
    group_distribution = vote_distribution_by_group(question)

    bootstrap_table do |table|
      table.headers = [
        t('activerecord.models.option.one').capitalize,
        t('activerecord.models.vote.many').capitalize,
        t('results.percentage')
      ]
      table.headers << t('groups.supporters') unless question.voting.secret?
      table.rows = distribution.map do |(option, votes)|
        row = [
          option,
          votes,
          "#{(votes * 100.0 / votes_count).round(2)}%"
        ]

        unless question.voting.secret?
          row << string_list(group_distribution[option]&.map { |(group_name, group_votes)| "#{group_name} (#{group_votes} #{t('activerecord.models.vote.many')})" })
        end

        row
      end
    end
  end

  def question_column_chart(question)
    column_chart vote_distribution_query(question), download: true
  end

  def question_input_form(f, question)
    if current_group&.available_votes.to_i > 1
      question.options.map { |option| range_for_option(f, option) }.inject(:+) + total_votes_counter
    elsif current_group&.available_votes == 1
      f.collection_select :status, question.options, :id, :title, { include_blank: '' }, class: 'form-control', name: "votes[#{question.id}]"
    end
  end

  def question_group_summary(question)
    Vote.joins(:option)
        .where(group: current_group, options: { question: question })
        .group('options.title')
        .count
        .map { |k, v| "#{k} (#{v} votos)" }
        .join(', ')
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
