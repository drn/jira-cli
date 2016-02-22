module Jira
  class CLI < Thor

    desc "assign", "Assign a ticket to a user"
    method_option :assignee, aliases: "-a", type: :string, default: nil, lazy_default: "auto", banner: "ASSIGNEE"
    def assign(ticket=Jira::Core.ticket)
      Command::Assign.new(ticket, options).run
    end

  end

  module Command
    class Assign < Base

      attr_accessor :ticket, :options

      def initialize(ticket, options={})
        self.ticket = ticket
        self.options = options
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
          assignee = options['assignee'] || io.ask('Assignee?', default: 'auto')
          assignee == 'auto' ? '-1' : assignee
        )
      end

    end
  end
end
