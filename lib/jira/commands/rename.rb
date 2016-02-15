module Jira
  class CLI < Thor

    desc "rename", "Updates the summary of the input ticket"
    def rename(ticket=Jira::Core.ticket)
      Command::Rename.new(ticket).run
    end

  end

  module Command
    class Rename < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?
        return if summary.empty?
        api.patch "issue/#{ticket}",
          params:  params,
          success: on_success,
          failure: on_failure
      end

      def params
        {
          fields: {
            summary: summary
          }
        }
      end

      def on_success
        ->{ puts "Successfully updated ticket #{ticket}'s summary." }
      end

      def on_failure
        ->{ puts "No change made to ticket #{ticket}." }
      end

      def summary
        @summary ||= io.ask("New summary for ticket #{ticket}:", default: '')
      end

    end
  end
end
