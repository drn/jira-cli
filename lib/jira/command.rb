require 'tty-table'

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
