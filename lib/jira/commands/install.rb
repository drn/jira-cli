#
# Installation Script
#

module Jira
  class CLI < Thor

    desc "install", "Guides the user through JIRA installation"
    def install

      create_file(Jira::Core.url_path, nil, verbose:false) do
        self.io.ask("Enter your JIRA URL")
      end

      create_file(Jira::Core.auth_path, nil, verbose:false) do
        username = self.io.ask("Enter your JIRA username")
        # TODO - hide password input
        password = self.io.ask("Enter your JIRA password")
        "#{username}:#{password}"
      end

      Jira::Core.send(:discard_memoized)
    end

  end
end
