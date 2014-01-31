module Jira
  class CLI < Thor

    desc "copy", "Copies the url of the JIRA ticket into the clipboard"
    def copy(ticket=Jira::Core.ticket)
      `echo #{Jira::Core.url}/browse/#{ticket} | pbcopy`
    end

  end
end
