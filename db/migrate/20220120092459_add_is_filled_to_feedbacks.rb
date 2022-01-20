# frozen_string_literal: true

class AddIsFilledToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :is_filled, :boolean, default: false, null: false
  end
end
