# frozen_string_literal: true

class MakeGroupNumberOptional < ActiveRecord::Migration[6.0]
  def up
    change_column :groups, :number, :integer, null: true
    remove_index :groups, :number
  end

  def down
    change_column :groups, :number, :integer, null: false
    add_index :groups, :number, unique: true
  end
end
