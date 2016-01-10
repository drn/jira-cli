module Jira
  class CLI < Thor

    desc "delete", "Deletes a ticket in Jira and the git branch"
    def delete(ticket=Jira::Core.ticket)
    end

  end
end
