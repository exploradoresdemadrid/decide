# frozen_string_literal: true

module ApplicationHelper

  def current_group
    current_user&.group
  end

  def string_list(items)
    return unless items.present?

    content_tag(:ul) do
      items.map do |group_name|
        content_tag(:li) { group_name }
      end.inject(:+)
    end
  end
end
