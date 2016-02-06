module Jira
  class Log < Thor

    desc 'delete', 'Deletes logged work against the input ticket'
    def delete(ticket=Jira::Core.ticket)
      Command::Log::Delete.new(ticket).run
    end

  end

  module Command
    module Log
      class Delete < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return unless logs?
          api.delete endpoint,
            success: on_success,
            failure: on_failure
        end

      private

        def logs?
          if json.empty?
            puts "Ticket #{ticket} has no work logged."
            return false
          end
          true
        end

        def endpoint
          "issue/#{ticket}/worklog/#{to_delete['id']}"
        end

        def on_success
          ->{ puts "Successfully deleted #{to_delete['timeSpent']}." }
        end

        def on_failure
          ->{ puts "No logged work deleted." }
        end

        def to_delete
          @to_delete ||= logs[
            io.select("Select a worklog to delete:", logs.keys)
          ]
        end

        def logs
          @logs ||= (
            logs = {}
            json.each do |log|
              logs[description_for(log)] = log
            end
            logs
          )
        end

        def description_for(log)
          author = log['updateAuthor']['displayName']
          updated_at = Jira::Format.time(Time.parse(log['updated']))
          time_spent = log['timeSpent']
          "#{author} @ #{updated_at}: #{time_spent}"
        end

        def json
          @json ||= api.get("issue/#{ticket}/worklog")['worklogs']
        end

      end
    end
  end
end
