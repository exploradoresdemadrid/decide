# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.integer :number, null: false, unique: true
      t.integer :available_votes, null: false

      t.timestamps
    end

    add_index :groups, :name, unique: true
    add_index :groups, :number, unique: true
  end
end
