module Jira
  class CLI < Thor

    desc "describe", "Describes the input ticket"
    def describe(ticket=Jira::Core.ticket)
      Command::Describe.new(ticket).run
    end

  end

  module Command
    class Describe < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if json.empty?
        return if errored?
        render_table(header, [row])
      end

      def header
        [ 'Ticket', 'Assignee', 'Status', 'Summary' ]
      end

      def row
        [ ticket, assignee, status, summary ]
      end

      def errored?
        return false if errors.empty?
        puts errors
        true
      end

      def errors
        @errors ||= (json['errorMessages'] || []).join('. ')
      end

      def assignee
        (fields['assignee'] || {})['name'] || 'Unassigned'
      end

      def status
        (fields['status'] || {})['name'] || 'Unknown'
      end

      def summary
        truncate(json['fields']['summary'], 45)
      end

      def fields
        json['fields'] || {}
      end

      def json
        @json ||= api.get "issue/#{ticket}"
      end

    end
  end
end
