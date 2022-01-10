# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.string :content
      t.string :shared_key
      t.string :shared_key_hash
      t.integer :requester_id, null: false
      t.integer :respondent_id

      t.timestamps
    end
    add_foreign_key :feedbacks, :users, column: :requester_id
    add_foreign_key :feedbacks, :users, column: :respondent_id
  end
end
