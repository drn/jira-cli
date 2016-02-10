module Jira
  class Vote < Thor

    desc 'add', 'Vote for the input ticket'
    def add(ticket=Jira::Core.ticket)
      Command::Vote::Add.new(ticket).run
    end

  end

  module Command
    module Vote
      class Add < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if ticket.empty?

          api.post "issue/#{ticket}/votes",
            params:  "\"#{Jira::Core.username}\"",
            success: on_success,
            failure: on_failure
        end

      private

        def on_success
          ->{ puts "Successfully voted for ticket #{ticket}" }
        end

        def on_failure
          ->{ puts "No vote cast." }
        end

      end
    end
  end
end
