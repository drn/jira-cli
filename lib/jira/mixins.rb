module Jira
  class CLI < Thor

    require 'highline/import'
    include Thor::Actions

    protected

      #
      # @return [String] path to .jira_url file
      #
      def jira_url_path
        self.root_path + "/.jira_url"
      end

      #
      # @return [String] path to .jira_auth file
      #
      def jira_auth_path
        self.root_path + "/.jira_auth"
      end

      #
      # @return [String] path to root git directory
      #
      def root_path
        @root_path ||= ex "git rev-parse --show-toplevel"
      end

      #
      # @return [Highline] HighLine instance for handling input
      #
      def cli
        @highline ||= ::HighLine.new
      end

      #
      # @param command [String] command to run
      # @return [String] output of the run command
      #
      def ex(command)
        run(command, verbose:false, capture:true).strip
      end

  end
end
