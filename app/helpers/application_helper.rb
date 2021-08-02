# frozen_string_literal: true

module ApplicationHelper
  def current_group
    current_user&.group
  end

  def current_organization
    current_user.organization
  end

  def string_list(items)
    return unless items.present?

    content_tag(:ol) do
      items.map do |group_name|
        content_tag(:li) { group_name }
      end.inject(:+)
    end
  end

  def t_member_type(amount = :one)
    I18n.t("activerecord.attributes.organization.#{current_organization.member_type}.#{amount}")
  end

  def new_title(model, options = {})
    application_header(t("#{model_key(model)}.new"), options)
  end

  def edit_title(model, options = {})
    application_header(t("#{model_key(model)}.edit"), options)
  end

  def index_title(model, options = {})
    application_header(t("activerecord.models.#{model.name.downcase}.many").capitalize, options)
  end

  def application_header(text, options = {})
    content_tag :div, class: :header do
      elements = []
      elements << image_tag("icons/#{options[:icon]}.png", class: :icon) if options[:icon]
      elements << content_tag(:h1) { text }
      elements.inject(:+)
    end
  end

  def fa_icon(name, tooltip, options = {})
    options.merge!(title: tooltip) if tooltip.present?

    icon name, library: :font_awesome, **options
  end

  private

  def model_key(model)
    if model == Group
      "activerecord.attributes.organization.#{@organization.member_type}"
    else
      model.name.pluralize.downcase
    end
  end
end
