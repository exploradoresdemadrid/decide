class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls, id: :uuid do |t|
      t.string :name, null: false
      t.integer :status, null: false, default: 0
      t.text :summary
      t.text :description

      t.timestamps
    end
  end
end
