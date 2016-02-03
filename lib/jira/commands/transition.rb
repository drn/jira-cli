module Jira
  class CLI < Thor

    desc "transition", "Transitions the input ticket to the next state"
    def transition(ticket=Jira::Core.ticket)
      Command::Transition.new(ticket).run
    end

  end

  module Command
    class Transition < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?
        return if metadata.empty?
        return if transition.empty?
        api.post "issue/#{ticket}/transitions",
          params:  params,
          success: on_success,
          failure: on_failure
      end

    private

      def params
        { transition: { id: transition } }
      end

      def on_success
        ->{ puts "Transitioned ticket #{ticket} to #{transition_name}." }
      end

      def on_failure
        ->{ puts "Failed to transition ticket #{ticket}." }
      end

      def transition_name
        transitions.invert[transition]
      end

      def transition
        @transition ||= transitions[
          io.select("Transition #{ticket} to:", transitions.keys)
        ]
      end

      def transitions
        @transitions ||= (
          transitions = {}
          metadata['transitions'].each do |transition|
            transitions[transition['to']['name']] = transition['id']
          end
          transitions
        )
      end

      def metadata
        @metadata ||= api.get("issue/#{ticket}/transitions")
      end

    end
  end
end
