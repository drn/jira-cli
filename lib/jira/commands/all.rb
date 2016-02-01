module Jira
  class CLI < Thor

    desc "all", "Describes all local branches that match JIRA ticketing syntax"
    def all
      Command::All.new.run
    end

  end

  module Command
    class All < Base

      def run
        puts 'No tickets' and return if tickets.empty?
        return if json.empty?
        return if errored?
        render_table(header, rows)
      end

    private

      def header
        [ 'Ticket', 'Assignee', 'Status', 'Summary' ]
      end

      def rows
        json['issues'].map do |issue|
          [
            issue['key'],
            issue['fields']['assignee']['name'] || 'Unassigned',
            issue['fields']['status']['name'] || 'Unknown',
            truncate(issue['fields']['summary'], 45)
          ]
        end
      end

      def errored?
        return false if errors.empty?
        puts errors
        true
      end

      def errors
        @errors ||= (json['errorMessages'] || []).join('. ')
      end

      def json
        @json ||= api.get "search", params: params
      end

      def params
        {
          jql: "key in (#{tickets.join(',')})"
        }
      end

      def tickets
        @tickets ||= (
          tickets = []
          branches.each do |branch|
            ticket = branch.delete('*').strip
            tickets << ticket if Jira::Core.ticket?(ticket, false)
          end
          tickets
        )
      end

      def branches
        `git branch`.strip.split("\n")
      end

    end
  end
end
