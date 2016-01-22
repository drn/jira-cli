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

    end
  end
end
