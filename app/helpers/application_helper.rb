# frozen_string_literal: true

module ApplicationHelper
    
    def encryption_ready?
        !current_user.must_change_password && cookies.encrypted[:encryption_password]
    end
end
