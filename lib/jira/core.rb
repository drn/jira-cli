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
        @url ||= ENV['JIRA_URL'] || self.read(self.cli_path)[:global]['url']
      end

      #
      # @return [String] JIRA username
      #
      def username
        @username ||= ENV['JIRA_USERNAME'] || self.read(self.cli_path)[:global]['username']
      end

      #
      # @return [String] JIRA password
      #
      def password
        @password ||= ENV['JIRA_PASSWORD'] || self.read(self.cli_path)[:global]['password']
      end

      #
      # @return [String] default ticket is the current branch
      #
      def ticket
        `git rev-parse --abbrev-ref HEAD`.strip
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
        @cli_path ||= self.root_path + "/.jira-cli"
      end

      #
      # @return [String] path of root git directory
      #
      def root_path
        return @root_path if !@root_path.nil?
        raise GitException.new if !system('git rev-parse 2> /dev/null')
        @root_path ||= `git rev-parse --show-toplevel`.strip
      end

      protected

        ### Core Actions

        #
        # Discards memozied class variables
        #
        def discard_memoized
          @url = nil
          @username = nil
          @password = nil
        end

        #
        # Validates the location and reads the contents of the input path
        #
        # @param path [String] path of file to read
        #
        # @return [Object] IniFile object of the file at the input path
        #
        def read(path)
          self.validate_path!(path)
          IniFile.load(path, { :comment => '#', :encoding => 'UTF-8' })
        end

        #
        # Aborts command if no file at the input path exists.
        #
        # @param path [String] path to validate
        #
        def validate_path!(path)
          raise InstallationException.new if !File.exists?(path)
        end

    end
  end
end
