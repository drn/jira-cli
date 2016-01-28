require_relative '../command'

module Jira
  class CLI < Thor

    desc "tickets", "List the tickets of the input username"
    def tickets(username=Jira::Core.username)
      Command::Tickets.new(username).run
    end
  end

  module Command
    class Tickets < Base

      attr_accessor :username

      def initialize(username)
        self.username = username
      end

      def run
        return if username.empty?
        return if metadata.empty?

        issues = metadata['issues']
        if !issues.nil? and issues.count > 0
          issues.each do |issue|
            ticket = issue['key']

            printf "[%2d]", issues.index(issue)
            puts "  #{Jira::Format.ticket(ticket)}"
          end
        else
          puts "There are no tickets for username #{username}."
        end
      end

      private

      def metadata
        @metadata ||= api.get("search?jql=assignee=#{username}")
      end

    end
  end
end
