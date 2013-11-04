module Jira
  class CLI < Thor

    desc "version", "Displays the version"
    def version
      say "jira #{Jira::VERSION}"
    end

    desc "install", "Guides the user through JIRA installation"
    def install
      # TODO
    end

  end
end
