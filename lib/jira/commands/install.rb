require_relative '../command'

module Jira
  class CLI < Thor

    desc "install", "Guides the user through JIRA CLI installation"
    def install
      Command::Install.new.run
    end

  end

  module Command
    class Install < Base

      def run
        io.say('Please enter your JIRA information.')
        inifile[:global] = params
        inifile.write
        Jira::Core.send(:discard_memoized)
      end

    private

      def params
        args = {
          url:      url,
          username: username,
        }
        response = io.select("Select an authentication type:", ["basic", "token"])
        case response
        when "basic"
          args[:password] = password
        when "token"
          args[:token] = token
        else
          raise InstallationException
        end
        args
      end

      def url
        io.ask("JIRA URL:")
      end

      def username
        io.ask("JIRA username:")
      end

      def password
        io.mask("JIRA password:")
      end

      def token
        io.ask("JIRA token:")
      end

      def inifile
        @inifile ||= IniFile.new(
          comment:  '#',
          encoding: 'UTF-8',
          filename: Jira::Core.cli_path
        )
      end

    end
  end
end
