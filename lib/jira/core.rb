#
# Version and Installation
#

require 'highline/import'

module Jira
  class CLI < Thor
    include Thor::Actions

    desc "version", "Displays the version"
    def version
      say "jira #{Jira::VERSION}"
    end

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

    end

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
