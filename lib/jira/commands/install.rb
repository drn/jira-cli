module Jira
  class CLI < Thor

    desc "install", "Guides the user through JIRA CLI installation"
    def install
      Command::Install.new.run
    end

    no_tasks do
      def try_install_cookie
        return false if Jira::Core.cookie.empty?
        puts "  ... cookie expired, renewing your cookie"
        Command::Install.new.run_rescue_cookie
        puts "Cookie renewed, please retry your last command."
        return true
      rescue Interrupt, StandardError
        false
      end
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
          response = cookie(session_params)
          inifile[:cookie] = {}
          inifile[:cookie][:name] = response['name']
          inifile[:cookie][:value] = response['value']
        end
        inifile.write
      end

      def run_rescue_cookie
        response = cookie(rescue_cookie_params)
        config = Jira::Core.config
        config[:cookie] = {}
        config[:cookie][:name] = response['name']
        config[:cookie][:value] = response['value']
        config.write
      end

    private

      def base_params
        {
          url:      url,
          username: username
        }
      end

      def rescue_cookie_params
        {
          username: Jira::Core.username,
          password: password
        }
      end

      def session_params
        {
          username: username,
          password: password
        }
      end

      def authentication
        @authentication ||= io.select(
          "Select an authentication type:",
          ["basic", "cookie", "token"]
        )
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

      def cookie(params)
        response = auth_api.post('session', params: params)
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
