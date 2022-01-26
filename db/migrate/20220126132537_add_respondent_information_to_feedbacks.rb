# frozen_string_literal: true

class AddRespondentInformationToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :respondent_information, :string
  end
end
