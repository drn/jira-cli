module Jira
  class CLI < Thor

    desc "browse", "Opens the current input ticket in your browser"
    def browse(ticket=nil)
      ticket ||= `git rev-parse --abbrev-ref HEAD`
      system("open #{Jira::Core.url}/browse/#{ticket}")
    end

  end
end
