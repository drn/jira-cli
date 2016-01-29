require_relative '../command'

module Jira
  class CLI < Thor

    desc "watch", "Watch against the input ticket"
    def watch(ticket=Jira::Core.ticket)
      Command::Watch.new(ticket).run
    end

    desc "watchers", "List the watchers of the input ticket"
    def watchers(ticket=Jira::Core.ticket)
      Command::Watchers.new(ticket).run
    end

    desc "unwatch", "Unwatch against the input ticket"
    def unwatch(ticket=Jira::Core.ticket)
      Command::Unwatch.new(ticket).run
    end

  end

  module Command
    class Watch < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?

        api.post "issue/#{ticket}/watchers",
          params:  Jira::Core.username,
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


    class Watchers < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?
        return if metadata.empty?

        watchers = metadata['watchers']
        if !watchers.nil? and watchers.count > 0
          watchers.each do |watcher|
            displayName = watcher['displayName']

            printf "[%2d]", watchers.index(watcher)
            puts "  #{Jira::Format.user(displayName)}"
          end
        else
          puts "There are no watchers on ticket #{ticket}."
        end
      end

      private

      def metadata
        @metadata ||= api.get("issue/#{ticket}/watchers")
      end
    end

    class Unwatch < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?

        username = Jira::Core.username
        api.delete "issue/#{ticket}/watchers?username=#{username}",
          success: on_success,
          failure: on_failure
      end

      private

      def on_success
        ->{ puts "Stopped watching ticket #{ticket}" }
      end

      def on_failure
        ->{ puts "No unwatch." }
      end

    end
  end
end
