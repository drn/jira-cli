module Jira
  class CLI < Thor

    desc "summarize", "Outputs the summary of the input ticket"
    def summarize(ticket=nil)
      ticket ||= ex('git rev-parse --abbrev-ref HEAD')
      json = self.query("issue/#{ticket}")
      summary = json['fields']['summary']
      status = json['fields']['status']['name']
      self.mutex.synchronize do
        say "#{self.colored_ticket(ticket)} "\
            "#{self.colored_status(status).center(26)} "\
            "#{self.colored_summary(summary)}"
      end
    end

    desc "all", "Summarizes all tickets that have local branches"
    def all
      tickets = []
      branches = ex("git branch").delete("*").split("\n")
      branches.each do |branch|
        stripped = branch.strip
        if !!stripped[/^[a-zA-Z]+-[0-9]+$/]
          tickets << stripped
        end
      end

      threads = []
      tickets.each do |ticket|
        threads << Thread.new{ self.summarize(ticket) }
      end
      threads.each{ |thread| thread.join }
    end

    protected

      def colored_ticket(ticket)
        "("\
        "#{Thor::Shell::Color::RED}"\
        "#{ticket}"\
        "#{Thor::Shell::Color::CLEAR}"\
        ")"
      end

      def colored_status(status)
        "["\
        "#{Thor::Shell::Color::BLUE}"\
        "#{status}"\
        "#{Thor::Shell::Color::CLEAR}"\
        "]"
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

      def mutex
        @mutex ||= Mutex.new
      end

      def client
        self.mutex.synchronize do
          return @client if !@client.nil?
          @client = Faraday.new
          username, password = self.jira_auth
          @client.basic_auth(username, password)
          return @client
        end
      end

  end
end
