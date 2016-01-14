#
# Installation Script
#

module Jira
  class CLI < Thor

    desc "install", "Guides the user through JIRA installation"
    def install

      inifile = IniFile.new(:comment => '#', :encoding => 'UTF-8', :filename => Jira::Core.cli_path)

      url = self.io.ask("Enter your JIRA URL")

      username = self.io.ask("Enter your JIRA username")
      password = self.io.ask("Enter your JIRA password", password: true)

      inifile[:global] = {
        url: url,
        username: username,
        password: password
      }
      inifile.write

      Jira::Core.send(:discard_memoized)
    end

  end
end
