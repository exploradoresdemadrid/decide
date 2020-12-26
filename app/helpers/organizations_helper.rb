module OrganizationsHelper
  def member_types_for_select
    Organization.member_types.keys.map { |k| [t("activerecord.attributes.organization.#{k}.many").capitalize, k] }.to_h
  end
end
