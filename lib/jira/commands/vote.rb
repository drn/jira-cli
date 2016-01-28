require_relative '../command'

module Jira
  class CLI < Thor

    desc "vote", "Vote against the input ticket"
    def vote(ticket=Jira::Core.ticket)
      Command::Vote.new(ticket).run
    end

    desc "votes", "List the votes of the input ticket"
    def votes(ticket=Jira::Core.ticket)
      Command::Votes.new(ticket).run
    end

    desc "unvote", "Unvote against the input ticket"
    def unvote(ticket=Jira::Core.ticket)
      Command::Unvote.new(ticket).run
    end

  end

  module Command
    class Vote < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?

        api.post "issue/#{ticket}/votes",
          params:  Jira::Core.username,
          success: on_success,
          failure: on_failure
      end

      private

      def on_success
        ->{ puts "Successfully added vote to ticket #{ticket}" }
      end

      def on_failure
        ->{ puts "No vote." }
      end

    end

    class Votes < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?
        return if metadata.empty?

        voters = metadata['voters']
        if !voters.nil? and voters.count > 0
          voters.each do |voter|
            displayName = voter['displayName']

            printf "[%2d]", voters.index(voter)
            puts "  #{Jira::Format.user(displayName)}"
          end
        else
          puts "There are no votes on ticket #{ticket}."
        end
      end

      private

      def metadata
        @metadata ||= api.get("issue/#{ticket}/votes")
      end
    end

    class Unvote < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?

        username = Jira::Core.username
        api.delete "issue/#{ticket}/votes?username=#{username}",
          success: on_success,
          failure: on_failure
      end

      private

      def on_success
        ->{ puts "Successfully removed vote from ticket #{ticket}" }
      end

      def on_failure
        ->{ puts "No unvote." }
      end

    end
  end
end
