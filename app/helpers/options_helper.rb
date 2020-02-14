# frozen_string_literal: true

module OptionsHelper
  def range_for_option(f, option)
    f.label(option.title) +
      content_tag(:input,
                  nil,
                  name: "votes[#{option.question.id}][#{option.id}]",
                  type: :range,
                  class: 'custom-range',
                  min: 0,
                  max: (current_group&.available_votes || 10),
                  value: 0)
  end
end
