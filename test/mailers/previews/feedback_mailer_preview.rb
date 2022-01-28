# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/feedback_mailer
class FeedbackMailerPreview < ActionMailer::Preview
  def send_creation_feedback_email
    FeedbackMailer.with(email: 'test@example.net', link: 'http://localhost:3000/',
                        user: User.new(first_name: 'Vincent', last_name: 'Hardouin')).new_request_email
  end

  def send_submitting_feedback_email
    FeedbackMailer.with(email: 'test@example.net', link: 'http://localhost:3000/',
                        user: User.new(first_name: 'Vincent', last_name: 'Hardouin')).new_received_email
  end
end
