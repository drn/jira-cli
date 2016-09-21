module Jira
  class Vote < Thor

    desc 'delete', 'Delete vote for the input ticket'
    def delete(ticket)
      Command::Vote::Delete.new(ticket).run
    end

  end

  module Command
    module Vote
      class Delete < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if ticket.empty?

          api.delete endpoint,
            success: on_success,
            failure: on_failure
        end

      private

        def endpoint
          "issue/#{ticket}/votes?username=#{Jira::Core.username}"
        end

        def on_success
          ->{ puts "Successfully removed vote from ticket #{ticket}" }
        end

        def on_failure
          ->{ puts "No unvote." }
        end

      end
    end
  end
end
