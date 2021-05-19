# frozen_string_literal: true

require 'http'

class EventFetcher
  class Error < StandardError; end

  def initialize(url)
    @url = url
  end

  def get
    response = HTTP.get(url)
    return JSON.parse(response.body) if response.status.success?

    raise JSON.parse(response.body).fetch('message', 'Invalid request') if response.status.client_error?

    raise 'Server error'
  rescue StandardError => e
    puts e.message
    raise Error, e.message
  end

  private

  attr_reader :url
end
