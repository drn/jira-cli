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
        return @jira_url if !@jira_url.nil?
        path = self.jira_url_path
        self.validate_path!(path)
        @jira_url ||= File.read(path).strip
      end

      #
      # @return [String] JIRA authorization
      #
      # @return [String] username
      # @return [String] password
      #
      def jira_auth
        if !@username.nil? && !@password.nil?
          return @username, @password
        end
        path = self.jira_auth_path
        self.validate_path!(path)
        @username, @password = File.read(path).strip.split(':')
        return @username, @password
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

      def validate_path!(path)
        if !File.exists?(path)
          say "Please run `jira install` before running this action..."
          abort
        end
      end

      def discard_memoized
        @username = nil
        @password = nil
        @jira_url = nil
      end

  end
end
