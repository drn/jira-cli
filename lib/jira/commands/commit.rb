module Jira
  class CLI < Thor

    desc "commit", "Commits uncommitted work with the ticket name and summary."
    def commit(ticket=Jira::Core.ticket)
      if Jira::Core.ticket?(ticket)
        self.api.get("issue/#{ticket}") do |json|
          `git commit -m '#{ticket}. #{json['fields']['summary'].periodize}'`
        end
      else
        puts "The ticket #{ticket} is not a valid JIRA ticket."
      end
    end

  end
end
