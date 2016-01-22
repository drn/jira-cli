module Jira
  class CLI < Thor

    desc "link", "Creates a link between two tickets in JIRA"
    def link(ticket=Jira::Core.ticket)
      self.api.get("issueLinkType") do |json|
        # determine issue link type
        issue_link_type = select_issue_link_type(json)
        break if issue_link_type.nil?

        # determine outward ticket
        outward_ticket = self.io.ask("Outward ticket:").strip
        break if !Jira::Core.ticket?(outward_ticket)

        # determine api parameters
        params = {
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

        self.api.post("issueLink", params) do |json|
          puts "Successfully linked ticket #{ticket} to ticket #{outward_ticket}."
          return
        end
      end
      puts "No ticket linked."
    end

    protected

      #
      # Given the issue link type metadata, prompts the user for
      # the issue link type to use, then return the issue link
      # type hash
      #
      # @param json [Hash] issue link type metadata
      #
      # @return [Hash] selected issue link type metadata
      #
      def select_issue_link_type(json)
        issue_link_types = {}
        json['issueLinkTypes'].each do |issue_link_type|
          data = {
            id:       issue_link_type['id'],
            name:     issue_link_type['name'],
            inward:   issue_link_type['inward'],
            outward:  issue_link_type['outward']
          }
          issue_link_types[issue_link_type['name']] = data
        end
        issue_link_types['Cancel'] = nil
        choice = self.io.select("Select a link type:", issue_link_types.keys)
        return issue_link_types[choice]
      end

  end
end
