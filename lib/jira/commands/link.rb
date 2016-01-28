require_relative '../command'

module Jira
  class CLI < Thor

    desc "link", "Creates a link between two tickets in JIRA"
    def link(ticket=Jira::Core.ticket)
      Command::Link.new(ticket).run
    end

  end

  module Command
    class Link < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if ticket.empty?
        return if metadata.empty?
        return if issue_link_type.empty?
        return if outward_ticket.empty?
        return unless invalid_ticket?

        begin
          api.post "issueLink",
            params: params,
            success: on_success,
            failure: on_failure
        rescue CommandException
        end
      end

      private

      def params
        {
          type: {
            name: issue_link_type[:name]
          },
          inwardIssue: {
            key: ticket
          },
          outwardIssue: {
            key: outward_ticket
          }
        }
      end

      def issue_link_type
        return @issue_link_type unless @issue_link_type.nil?

        types = {}
        metadata['issueLinkTypes'].each do |type|
          data = {
            id:       type['id'],
            name:     type['name'],
            inward:   type['inward'],
            outward:  type['outward']
          }
          types[type['name']] = data
        end
        choice = io.select("Select a link type:", types.keys)
        @issue_link_type = types[choice]
      end

      def on_success
        ->{ puts "Successfully linked ticket #{ticket} to ticket #{outward_ticket}." }
      end

      def on_failure
        ->{ puts "No ticket linked." }
      end

      def outward_ticket
        @outward_ticket ||= io.ask("Outward ticket:").strip
      end

      def invalid_ticket?
        return true unless Jira::Core.ticket?(outward_ticket)
        return false
      end

      def metadata
        @metadata ||= api.get("issueLinkType")
      end

    end
  end
end
