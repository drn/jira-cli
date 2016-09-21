module Jira
  class Watch < Thor

    desc 'delete', 'Stop watching the input ticket'
    def delete(ticket)
      Command::Watch::Delete.new(ticket).run
    end

  end

  module Command
    module Watch
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
          "issue/#{ticket}/watchers?username=#{Jira::Core.username}"
        end

        def on_success
          ->{ puts "Stopped watching ticket #{ticket}" }
        end

        def on_failure
          ->{ puts "Did not stop watching ticket." }
        end

      end
    end
  end
end
