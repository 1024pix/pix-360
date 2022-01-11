# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :giver, class_name: 'User', optional: true, foreign_key: 'respondent_id', inverse_of: :given_feedbacks
  belongs_to :requester, class_name: 'User', inverse_of: :received_feedbacks
end
