# frozen_string_literal: true

module OptionsHelper
  def range_for_option(f, option)
    content_tag(:div, class: 'option-block') do
      f.label(option.title, class: 'col-md-3 col-sm-12 col-12') +
        content_tag(:input,
                    nil,
                    name: "votes[#{option.question.id}][#{option.id}]",
                    type: :range,
                    class: 'custom-range col-md-7 col-sm-10 col-10',
                    min: 0,
                    max: (votes_available(option.question) || 10),
                    value: 0) +
        content_tag(:span, '0', class: 'counter col-2')
    end
  end

  def total_votes_counter(question)
    content_tag(:hr) +
      content_tag(:div, class: 'vote-summary') do
        content_tag(:label, t('votes.total'), class: 'col-md-10 col-sm-10 col-10') +
          content_tag(:span, "0/#{votes_available(question) || 0}", class: 'total-votes-counter col-2', data: {total: votes_available(question) || 0})
      end
  end
end
