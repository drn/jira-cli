require 'faraday'
require 'faraday_middleware'

require_relative './api'

module Jira
  class AuthAPI < API

  protected

    def endpoint
      "#{Jira::Core.url}/rest/auth/1"
    end

  end
end
