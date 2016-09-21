module Jira
  class Watch < Thor

    desc 'add', 'Watch the input ticket'
    def add(ticket)
      Command::Watch::Add.new(ticket).run
    end

  end

  module Command
    module Watch
      class Add < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if ticket.empty?

          api.post "issue/#{ticket}/watchers",
            params:  "\"#{Jira::Core.username}\"",
            success: on_success,
            failure: on_failure
        end

      private

        def on_success
          ->{ puts "Now watching ticket #{ticket}" }
        end

        def on_failure
          ->{ puts "No watch." }
        end

      end
    end
  end
end
