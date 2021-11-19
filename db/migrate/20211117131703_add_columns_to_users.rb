# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :must_change_password, default: true
      t.string :private_key
      t.string :public_key
    end
  end
end
