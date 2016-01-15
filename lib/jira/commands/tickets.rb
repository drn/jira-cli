module Jira
  class CLI < Thor

    desc "tickets", "List the tickets of the input username"
    def tickets(username=Jira::Core.username)
      self.api.get("search?jql=assignee=#{username}") do |json|
        issues = json['issues']
        if issues.count > 0
          issues.each do |issue|
            ticket = issue['key']

            printf "[%2d]", issues.index(issue)
            puts "  #{Jira::Format.ticket(ticket)}"
          end
        else
          puts "There are no tickets for username #{username}."
        end
      end
    end

  end
end
