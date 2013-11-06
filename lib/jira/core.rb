module Jira
  class Core
    class << self

      #
      # Memoizes url, username, and password
      #
      def setup
        self.url
        self.auth
      end

      ### Virtual Attributes

      #
      # @return [String] JIRA project endpoint
      #
      def url
        @url ||= self.read(self.url_path)
      end

      #
      # @return [String] JIRA username
      #
      def username
        @username ||= self.auth.first
      end

      #
      # @return [String] JIRA password
      #
      def password
        @password ||= self.auth.last
      end

      ### Relevant Paths

      #
      # @return [String] path to .jira-url file
      #
      def url_path
        @url_path ||= self.root_path + "/.jira-url"
      end

      #
      # @return [String] path to .jira-auth file
      #
      def auth_path
        @auth_path ||= self.root_path + "/.jira-auth"
      end

      #
      # @return [String] path of root git directory
      #
      def root_path
        return @root_path if !@root_path.nil?
        if !system('git rev-parse')
          puts "JIRA commands can only be run within a git repository."
          abort
        end
        @root_path ||= `git rev-parse --show-toplevel`.strip
      end

      protected

        #
        # Determines and parses the auth file
        #
        # @return [String] JIRA username
        # @return [String] JIRA password
        #
        def auth
          self.read(self.auth_path).split(':')
        end

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
        # @return [String] contents of the file at the input path
        #
        def read(path)
          self.validate_path!(path)
          File.read(path).strip
        end

        #
        # Aborts command if no file at the input path exists.
        #
        # @param path [String] path to validate
        #
        def validate_path!(path)
          if !File.exists?(path)
            say "Please run `jira install` before running this command."
            abort
          end
        end

    end
  end
end
