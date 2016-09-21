module Jira
  class Watch < Thor

    desc 'list', 'Lists the watchers of the input ticket'
    def list(ticket)
      Command::Watch::List.new(ticket).run
    end

  end

  module Command
    module Watch
      class List < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if ticket.empty?
          return if watchers.nil?
          return if no_watchers?

          watchers.each do |watcher|
            self.watcher = watcher
            display_watcher
          end
        end

      private

        attr_accessor :watcher

        def no_watchers?
          if watchers.count == 0
            puts "Ticket #{ticket} has no watchers."
            return true
          end
          false
        end

        def display_watcher
          puts "[#{watchers.index(watcher).to_s.rjust(2)}]  #{display_name}"
        end

        def display_name
          Jira::Format.user(watcher['displayName'])
        end

        def watchers
          @watchers ||= api.get("issue/#{ticket}/watchers")['watchers']
        end

      end
    end
  end
end
