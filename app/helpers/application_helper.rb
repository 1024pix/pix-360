# frozen_string_literal: true

require 'redcarpet'

module ApplicationHelper
  def encryption_ready?
    !current_user.must_change_password && cookies.encrypted[:encryption_password]
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Rails/OutputSafety
  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: '_blank' },
      space_after_headers: true,
      fenced_code_blocks: true
    }
    extensions = {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true
    }

    renderer = ::Redcarpet::Render::HTML.new(options)
    markdown = ::Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Rails/OutputSafety
end
