# frozen_string_literal: true

module VotingsHelper
  def votings_table(organization, votings)
    bootstrap_table do |table|
      table.headers = [t('title'), t('status')]
      table.headers << t('edit') if can?(:edit, Voting)
      table.headers << t('destroy') if can?(:destroy, Voting)

      votings.each do |voting|
        row = [link_to(voting.title, organization_voting_path(organization, voting)), voting.status.capitalize ]
        row << link_to(t('edit'), edit_organization_voting_path(organization, voting)) if can?(:edit, Voting)
        row << link_to(t('destroy'), organization_voting_path(organization, voting), method: :delete, data: { confirm: 'Are you sure?' }) if can?(:destroy, Voting)

        table.rows << row
      end
    end
  end

  def groups_with_vote_submitted(voting)
    string_list(voting.groups.pluck(:name))
  end

  def groups_without_vote_submitted(voting)
    string_list(voting.organization.groups.where.not(id: voting.groups.select(:id)).pluck(:name))
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
      content_tag(:div, class: 'question') do
        content_tag(:h4, question.title) +
          content_tag(:p, question.description) +
          question_input_form(f, question)
      end
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

  def timeout_in_seconds_for_select
    {
      0 => 'Unlimited',
      30 => '30 seconds',
      60 => '1 minute',
      300 => '5 minutes'
    }
  end

  def secret_voting_alert(voting)
    alert_box(dismissible: true) { t(voting.secret? ? 'is_secret' : 'is_not_secret') }
  end

  def voting_column_chart(voting)
    results = Option.yes
                    .left_outer_joins(:votes)
                    .joins(:question)
                    .where('questions.voting_id' => voting.id)
                    .group('questions.title')
                    .count('votes.id')
                    .sort_by { |_, v| -v }
    column_chart results, download: true
  end
end
