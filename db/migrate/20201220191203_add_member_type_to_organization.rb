class AddMemberTypeToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :member_type, :integer, null: false, default: 0
  end
end
