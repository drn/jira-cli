module Jira
  class AuthAPI < API

  protected

    def endpoint
      "#{Jira::Core.url}/rest/auth/1"
    end

  end
end
