module Jira
  class CLI < Thor

    desc "tickets [jql]", "List the tickets of the input jql"
    def tickets(jql="assignee=#{Jira::Core.username}")
      Command::Tickets.new(jql).run
    end

  end

  module Command
    class Tickets < Base

      attr_accessor :jql

      def initialize(jql)
        self.jql = jql
      end

      def run
        return if jql.empty?
        return if metadata.empty?
        return unless metadata['errorMessages'].nil?

        puts "There are no tickets for jql=#{jql}." and return if rows.empty?
        render_table(header, rows)
      end

    private

      def header
        [ 'Ticket', 'Assignee', 'Status', 'Summary']
      end

      def rows
        metadata['issues'].map do |issue|
          [
            issue['key'],
            issue['fields']['assignee']['name'] || 'Unassigned',
            issue['fields']['status']['name'] || 'Unknown',
            truncate(issue['fields']['summary'], 45)
          ]
        end
      end

      def metadata
        @metadata ||= api.get("search?jql=#{jql}")
      end

    end
  end
end
