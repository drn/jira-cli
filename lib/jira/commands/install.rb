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
        inifile[:global] = base_params
        inifile.write # Do this now because cookie authentication uses api calls

        inifile.delete_section("cookie") if inifile.has_section?("cookie")
        case authentication
        when "basic"
          inifile[:global][:password] = password
        when "token"
          inifile[:global][:token] = token
        when "cookie"
          response = cookie
          inifile[:cookie] = {}
          inifile[:cookie][:name] = response['name']
          inifile[:cookie][:value] = response['value']
        end
        inifile.write
      end

    private

      def base_params
        {
          url:      url,
          username: username,
        }
      end

      def session_params
        {
          username: username,
          password: password
        }
      end

      def authentication
        @authentication ||= io.select("Select an authentication type:", ["basic", "cookie", "token"])
      end

      def url
        @url ||= io.ask("JIRA URL:")
      end

      def username
        @username ||= io.ask("JIRA username:")
      end

      def password
        io.mask("JIRA password:")
      end

      def token
        io.ask("JIRA token:")
      end

      def cookie
        response = auth_api.post('session', params: session_params)
        return {} unless response['errorMessages'].nil?
        response['session']
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
