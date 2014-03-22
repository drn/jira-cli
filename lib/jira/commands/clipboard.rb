module Jira
  class CLI < Thor

    desc "clipboard", "Copies the url of the JIRA ticket into the clipboard"
    def clipboard(ticket=Jira::Core.ticket)
      `echo #{Jira::Core.url}/browse/#{ticket} | pbcopy`
    end

  end
end
