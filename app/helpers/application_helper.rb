# frozen_string_literal: true

module ApplicationHelper

  def current_group
    current_user&.group
  end

  def string_list(items)
    return unless items.present?

    content_tag(:ol) do
      items.map do |group_name|
        content_tag(:li) { group_name }
      end.inject(:+)
    end
  end

  def new_title(model)
    content_tag(:h1) { t("#{model.name.pluralize.downcase}.new") }
  end

  def edit_title(model)
    content_tag(:h1) { t('edit') + ' ' + t("activerecord.models.#{model.name.downcase}.one") }
  end

  def index_title(model)
    content_tag(:h1) { t("activerecord.models.#{model.name.downcase}.many").capitalize }
  end
end
