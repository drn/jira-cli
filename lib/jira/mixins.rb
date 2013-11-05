module Jira
  class CLI < Thor

    require 'highline/import'
    require 'json'
    require 'faraday'
    include Thor::Actions
    include Thor::Shell

    protected

      #
      # @return [String] JIRA endpoint
      #
      def jira_url
        @jira_url ||= File.read(self.jira_url_path).strip
      end

      #
      # @return [String] JIRA authorization
      #
      # @return [String] username
      # @return [String] password
      #
      def jira_auth
        File.read(self.jira_auth_path).strip.split(':')
      end

      #
      # @return [String] path to .jira-url file
      #
      def jira_url_path
        @url_path ||= self.root_path + "/.jira-url"
      end

      #
      # @return [String] path to .jira-auth file
      #
      def jira_auth_path
        @auth_path ||= self.root_path + "/.jira-auth"
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
      # Execute shell command
      #
      # @param command [String] command to run
      # @return [String] output of the run command
      #
      def ex(command)
        run(command, verbose:false, capture:true).strip
      end

      def discard_memozied
        @jira_url = nil
      end

  end
end
