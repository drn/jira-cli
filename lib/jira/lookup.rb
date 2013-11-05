module Jira
  class CLI < Thor

    desc "summarize", "Outputs the summary of the input ticket"
    def summarize(ticket=nil)
      ticket ||= ex('git rev-parse --abbrev-ref HEAD')
      json = self.query("issue/#{ticket}")
      summary = json['fields']['summary']
      say self.colored_ticket(ticket) + " " + self.colored_summary(summary)
    end

    protected

      def colored_ticket(ticket)
        "("\
        "#{Thor::Shell::Color::RED}"\
        "#{ticket}"\
        "#{Thor::Shell::Color::CLEAR}"\
        ")"
      end

      def colored_summary(summary)
        "#{Thor::Shell::Color::BOLD}"\
        "#{Thor::Shell::Color::WHITE}"\
        "#{summary}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def query(path)
        response = self.client.get "#{self.jira_url}/rest/api/2/#{path}"
        return JSON.parse(response.body)
      end

      def client
        return @client if !@client.nil?
        @client = Faraday.new
        username, password = self.jira_auth
        @client.basic_auth(username, password)
        return @client
      end

  end
end
