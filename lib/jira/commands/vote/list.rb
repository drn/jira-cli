module Jira
  class Vote < Thor

    desc 'list', "List the votes on the input ticket"
    def list(ticket=Jira::Core.ticket)
      Command::Vote::List.new(ticket).run
    end

  end

  module Command
    module Vote
      class List < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if ticket.empty?
          return if voters.nil?
          return if no_voters?

          voters.each do |voter|
            self.voter = voter
            display_voter
          end
        end

      private

        attr_accessor :voter

        def display_voter
          puts "[#{voters.index(voter).to_s.rjust(2)}] #{display_name}"
        end

        def display_name
          Jira::Format.user(voter['displayName'])
        end

        def no_voters?
          if voters.count == 0
            puts "There are no votes on ticket #{ticket}."
            return true
          end
          return false
        end

        def voters
          @voters ||= api.get("issue/#{ticket}/votes")['voters']
        end

      end
    end
  end
end
