module Jira
  class Log < Thor

    desc 'add', 'Logs work against the input ticket'
    def add(ticket=Jira::Core.ticket)
      Command::Log::Add.new(ticket).run
    end

  end

  module Command
    module Log
      class Add < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if time_spent.empty?
          api.post "issue/#{ticket}/worklog",
            params:  params,
            success: on_success,
            failure: on_failure
        end

      private

        def params
          { timeSpent: time_spent }
        end

        def time_spent
          @time_spent ||= io.ask("Time spent on ticket #{ticket}:")
        end

        def on_success
          ->{ puts "Successfully logged #{time_spent} on ticket #{ticket}." }
        end

        def on_failure
          ->{ puts "No work was logged on ticket #{ticket}." }
        end

      end
    end
  end
end
