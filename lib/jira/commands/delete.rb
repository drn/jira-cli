module Jira
  class CLI < Thor

    desc "delete", "Deletes a ticket"
    method_option :force, type: :boolean, default: false
    def delete(ticket)
      Command::Delete.new(ticket, options[:force]).run
    end

  end

  module Command
    class Delete < Base

      attr_accessor :ticket, :force

      def initialize(ticket, force)
        self.ticket = ticket
        self.force = force
      end

      def run
        return if ticket.empty?
        return if metadata.empty?
        return if metadata['fields'].nil?
        return if subtasks_failure?

        api.delete "issue/#{ticket}?deleteSubtasks=#{force}",
          success: ->{ puts "Ticket #{ticket} has been deleted." },
          failure: ->{ puts "No change made to ticket #{ticket}." }
      end

    private

      def subtasks_failure?
        return false unless subtask?
        if !metadata['fields']['subtasks'].empty? && !force
          self.force = io.yes?("Delete all sub-tasks for ticket #{ticket}?")
          return true unless force
        end
        false
      end

      def subtask?
        metadata['fields']['issuetype']['subtask']
      end

      def metadata
        @metadata ||= api.get("issue/#{ticket}")
      end

    end
  end
end
