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

  def new_title(model, options = {})
    application_header(t("#{model.name.pluralize.downcase}.new"), options)
  end

  def edit_title(model, options = {})
    application_header(t('edit') + ' ' + t("activerecord.models.#{model.name.downcase}.one"), options)
  end

  def index_title(model, options = {})
    application_header(t("activerecord.models.#{model.name.downcase}.many").capitalize, options)
  end

  def application_header(text, options = {})
    content_tag :div, class: :header do
      elements = []
      elements << image_tag(options[:icon], class: :icon) if options[:icon]
      elements << content_tag(:h1) { text }
      elements.inject(:+)
    end
  end

  def fa_icon(name, tooltip, options = {})
    options.merge!(title: tooltip) if tooltip.present?

    icon name, library: :font_awesome, **options
  end
end
