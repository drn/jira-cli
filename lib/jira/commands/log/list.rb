module Jira
  class Log < Thor

    desc 'list', 'Lists work logged on the input ticket'
    def list(ticket=Jira::Core.ticket)
      Command::Log::List.new(ticket).run
    end

  end

  module Command
    module Log
      class List < Base

        attr_accessor :ticket

        def initialize(ticket=Jira::Core.ticket)
          self.ticket = ticket
        end

        def run
          if logs.empty?
            puts "Ticket #{ticket} has no work logged."
            return
          end
          render_table(header, rows)
        end

      private

        attr_accessor :log

        def header
          [ 'Author', 'Updated At', 'Time Spent' ]
        end

        def rows
          rows = []
          logs.each do |log|
            self.log = log
            rows << row
          end
          rows
        end

        def row
          [ author, updated_at, time_spent ]
        end

        def author
          log['updateAuthor']['displayName']
        end

        def updated_at
          Jira::Format.time(Time.parse(log['updated']))
        end

        def time_spent
          log['timeSpent']
        end

        def logs
          @logs ||= api.get("issue/#{ticket}/worklog")['worklogs']
        end

      end
    end
  end
end
