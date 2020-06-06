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
                    max: (current_group&.available_votes || 10),
                    value: 0) +
        content_tag(:span, '0', class: 'counter col-2')
    end
  end

  def total_votes_counter
    content_tag(:hr) +
      content_tag(:div, class: 'vote-summary') do
        content_tag(:label, t('total_votes'), class: 'col-md-10 col-sm-10 col-10') +
          content_tag(:span, "0/#{current_group&.available_votes || 0}", class: 'total-votes-counter col-2', data: {total: current_group&.available_votes || 0})
      end
  end
end
