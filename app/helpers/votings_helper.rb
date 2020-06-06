# frozen_string_literal: true

module VotingsHelper
  def groups_with_vote_submitted(voting)
    string_list(voting.groups.pluck(:name))
  end

  def groups_without_vote_submitted(voting)
    string_list(Group.where.not(id: voting.groups.select(:id)).pluck(:name))
  end

  def voting_questions_form(voting, f)
    if voting.is_a? SimpleVoting
      simple_questions_form(voting, f)
    else
      multiselect_questions_form(voting, f)
    end
  end

  def simple_questions_form(voting, f)
    voting.questions.map do |question|
      content_tag(:h4, question.title) +
        content_tag(:p, question.description) +
        question_input_form(f, question)
    end.inject(:+)
  end

  def multiselect_questions_form(voting, f)
    content_tag(:h4, t('options')) +
    voting.questions.map do |question|
      f.check_box :options,
                  { label: question.title, name: "votes[#{question.id}][#{question.options.yes.first.id}]" },
                  current_group.available_votes, 0
    end.inject(:+)
  end

  def types_for_multiselect
    Voting.types.map do |type|
      { type.name => type.human_class_name }
    end.inject(:merge)
  end

  def secret_voting_alert(voting)
    alert_box { t(voting.secret? ? 'is_secret' : 'is_not_secret') }
  end

  def voting_column_chart(voting)
    results = Option.yes
                    .left_outer_joins(:votes)
                    .joins(:question)
                    .where('questions.voting_id' => voting.id)
                    .group('questions.title')
                    .count('votes.id')
                    .sort_by{|_, v| -v}
    column_chart results, download: true
  end
end
