#
# Installation Script
#

module Jira
  class CLI < Thor

    desc "install", "Guides the user through JIRA installation"
    def install
      say self.jira_url_path
      say self.jira_auth_path

      create_file self.jira_url_path, nil, verbose:false do
        self.cli.ask("Enter your JIRA URL: ")
      end

      create_file self.jira_auth_path, nil, verbose:false do
        username = self.cli.ask("Enter your JIRA username: ")
        password = self.cli.ask("Enter your JIRA password: ") do |q|
          q.echo = false
        end
        "#{username}:#{password}"
      end

      self.discard_memoized
    end

  end
end
