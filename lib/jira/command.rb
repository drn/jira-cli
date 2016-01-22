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

      def io
        @io ||= TTY::Prompt.new
      end

      def render_table(header, rows)
        puts TTY::Table.new(header, rows).render(:ascii, padding: [0,1])
      end

    end
  end
end
