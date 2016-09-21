module Jira
  class CLI < Thor

    desc "rename <ticket>", "Updates the summary of the input ticket"
    method_option :summary, aliases: "-s", type: :string, default: nil, lazy_default: "", banner: "SUMMARY"
    def rename(ticket)
      Command::Rename.new(ticket, options).run
    end

  end

  module Command
    class Rename < Base

      attr_accessor :ticket, :options

      def initialize(ticket, options)
        self.ticket = ticket
        self.options = options
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
        @summary ||= options['summary'] || io.ask("New summary for ticket #{ticket}:", default: '')
      end

    end
  end
end
