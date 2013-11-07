module Jira
  class CLI < Thor

    desc "version", "Displays the version"
    def version
      say "jira #{Jira::VERSION}"
    end

  end
end
