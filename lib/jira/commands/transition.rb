module Jira
  class CLI < Thor

    desc "transition", "Transitions the input ticket to the next state"
    method_option :transition, aliases: "-t", type: :string, default: nil, lazy_default: "", banner: "TRANSITION"
    def transition(ticket=Jira::Core.ticket)
      Command::Transition.new(ticket, options).run
    end

  end

  module Command
    class Transition < Base

      attr_accessor :ticket, :options

      def initialize(ticket, options)
        self.ticket = ticket
        self.options = options
      end

      def run
        return if ticket.empty?
        return if metadata.empty?
        return unless metadata['errorMessages'].nil?
        return if transition.nil? || transition.empty?
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
          options['transition'] || io.select("Transition #{ticket} to:", transitions.keys)
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
