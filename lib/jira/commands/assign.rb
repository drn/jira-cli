require_relative '../command'

module Jira
  class CLI < Thor

    desc "assign", "Assign a ticket to a user"
    def assign(ticket=Jira::Core.ticket)
      Command::Assign.new(ticket).run
    end

  end

  module Command
    class Assign < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        api.patch path,
          params:  params,
          success: on_success,
          failure: on_failure
      end

    private

      def on_success
        -> do
          puts "Ticket #{ticket} assigned to #{name}."
        end
      end

      def on_failure
        ->(json) do
          message = (json['errors'] || {})['assignee']
          puts message || "Ticket #{ticket} was not assigned."
        end
      end

      def path
        "issue/#{ticket}/assignee"
      end

      def params
        { name: assignee }
      end

      def name
        assignee == '-1' ? 'default user' : "'#{assignee}'"
      end

      def assignee
        @assignee ||= (
          assignee = io.ask('Assignee?', default: 'auto')
          assignee == 'auto' ? '-1' : assignee
        )
      end

    end
  end
end
