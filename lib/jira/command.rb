# internal dependencies
require 'jira/api'
require 'jira/sprint_api'
require 'jira/auth_api'
require 'jira/legacy_api'
require 'jira/core'
require 'jira/mixins'

module Jira
  module Command
    class Base

      def run
        raise NotImplementedError
      end

    protected

      def api
        @api ||= Jira::API.new
      end

      def auth_api
        @auth_api ||= Jira::AuthAPI.new
      end

      def body
        @body ||= (
          comment = io.ask("Leave a comment for ticket #{ticket}:").strip
          comment = comment.gsub(/\@[a-zA-Z]+/,'[~\0]') || comment
          comment.gsub('[~@','[~') || comment
        )
      end

      def sprint_api
        @sprint_api ||= Jira::SprintAPI.new
      end

      def io
        @io ||= TTY::Prompt.new
      end

      def render_table(header, rows)
        puts TTY::Table.new(header, rows).render(:ascii, padding: [0,1])
      end

      def truncate(string, limit=80)
        return string if string.length < limit
        string[0..limit-3] + '...'
      end

    end
  end
end

# load commands
commands_directory = File.join(File.dirname(__FILE__), 'commands', '*.rb')
Dir[commands_directory].each { |file| require file }
