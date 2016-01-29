module Jira
  class Core
    class << self

      #
      # Memoizes url, username, and password
      #
      def setup
        self.url
      end

      ### Virtual Attributes

      #
      # @return [String] JIRA project endpoint
      #
      def url
        @url ||= ENV['JIRA_URL'] || config[:global]['url']
      end

      #
      # @return [String] JIRA username
      #
      def username
        @username ||= ENV['JIRA_USERNAME'] || config[:global]['username']
      end

      #
      # @return [String] JIRA password
      #
      def password
        @password ||= ENV['JIRA_PASSWORD'] || config[:global]['password']
      end

      #
      # @return [String] default ticket is the current branch
      #
      def ticket
        `git rev-parse --abbrev-ref HEAD 2>/dev/null`.strip
      end

      #
      # Determines whether or not the input ticket matches the expected JIRA
      # ticketing syntax. Outputs a warning that the input ticket isn't a valid
      # ticket.
      #
      # @param ticket [String] input ticket name
      # @param verbose [Boolean] verbose output of the ticket warning
      #
      # @return [Boolean] whether input string matches JIRA ticket syntax
      #
      def ticket?(ticket, verbose=true)
        !!ticket.to_s[/^[a-zA-Z]+-[0-9]+$/] and return true
        if verbose
          puts "#{Jira::Format.ticket(ticket)} is not a valid JIRA ticket."
        end
        return false
      end

      ### Relevant Paths

      #
      # @return [String] path to .jira-cli file
      #
      def cli_path
        @cli_path ||= root_path + "/.jira-cli"
      end

    private

      def root_path
        @root_path ||= (
          root_path = `git rev-parse --show-toplevel 2>/dev/null`.strip
          raise GitException if root_path.empty?
          root_path
        )
      end

      def config
        @config ||= (
          raise InstallationException unless File.exists?(cli_path)
          IniFile.load(cli_path, comment: '#', encoding: 'UTF-8')
        )
      end

    end
  end
end
