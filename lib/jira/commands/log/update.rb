module Jira
  class Log < Thor

    desc 'update', 'Updates work logged on the input ticket'
    def update(ticket=Jira::Core.ticket)
      Command::Log::Update.new(ticket).run
    end

  end

  module Command
    module Log
      class Update < Base

        attr_accessor :ticket

        def initialize(ticket=Jira::Core.ticket)
          self.ticket = ticket
        end

        def run
          return unless logs?
          api.patch endpoint,
            params:  params,
            success: on_success,
            failure: on_failure
        end

      private

        def params
          { timeSpent: updated_time_spent }
        end

        def updated_time_spent
          io.ask('Updated time spent?')
        end

        def logs?
          if json.empty?
            puts "Ticket #{ticket} has no work logged."
            return false
          end
          true
        end

        def endpoint
          "issue/#{ticket}/worklog/#{to_update['id']}"
        end

        def on_success
          ->{ puts "Successfully updated #{to_update['timeSpent']}." }
        end

        def on_failure
          ->{ puts "No logged work updated." }
        end

        def to_update
          @to_delete ||= logs[
            io.select("Select a worklog to update:", logs.keys)
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
