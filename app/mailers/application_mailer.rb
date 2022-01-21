# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('notification@pix.fr', 'Pix 360')
  layout 'mailer'
end
