# frozen_string_literal: true

module VotingsHelper
  def groups_with_vote_submitted(voting)
    string_list(voting.groups.pluck(:name))
  end

  def groups_without_vote_submitted(voting)
    string_list(Group.where.not(id: voting.groups.select(:id)).pluck(:name))
  end

  def voting_questions_form(voting, f)
    voting.questions.map do |question|
      content_tag(:h4, question.title) +
        content_tag(:p, question.description) +
        question_input_form(f, question)
    end.inject(:+)
  end

  def types_for_multiselect
    Voting.types.map do |type|
      { type.name => type.human_class_name }
    end.inject(:merge)
  end

  def secret_voting_alert(voting)
    alert_box do
      if voting.secret?
        t('is_secret')
      else
        t('is_not_secret')
      end
    end
  end
end
