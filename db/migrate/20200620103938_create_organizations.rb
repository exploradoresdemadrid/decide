class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
