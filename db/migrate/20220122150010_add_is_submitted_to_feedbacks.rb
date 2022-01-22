# frozen_string_literal: true

class AddIsSubmittedToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :is_submitted, :boolean, default: false, null: false
  end
end
