module Jira
  class CLI < Thor

    desc "summarize", "Outputs the summary of the input ticket"
    def summarize(ticket=nil)
      ticket ||= `git rev-parse --abbrev-ref HEAD`.strip
      output_summary(ticket)
    end

    desc "all", "Summarizes all tickets that have local branches"
    def all
      tickets = []
      current_ticket = nil
      branches = `git branch`.strip.split("\n")
      branches.each do |branch|
        stripped = branch.delete('*').strip
        if !!stripped[/^[a-zA-Z]+-[0-9]+$/]
          tickets << stripped
          if branch.include?('*')
            current_ticket = stripped
          end
        end
      end

      threads = []
      tickets.each_with_index do |ticket, index|
        threads << Thread.new do
          output_summary(ticket, current_ticket==ticket)
        end
      end
      threads.each{ |thread| thread.join }
    end

    desc "comment", "Add a comment to the input ticket"
    def comment(ticket=nil)
      say "Coming soon"
      #ticket ||= ex('get rev-parse --abbrev-ref HEAD')
      #json = self.api_post("issue/#{ticket}")
    end

    desc "transition", "Transitions the input ticket to the next state"
    def transition(ticket=nil)
      say "Coming soon"
    end

    protected

      def output_summary(ticket, decoration=false)
        json = self.api_get("issue/#{ticket}")
        summary = json['fields']['summary']
        status = json['fields']['status']['name']
        self.mutex.synchronize do
          say "#{self.colored_ticket(ticket, decoration)} "\
              "#{self.colored_status(status).center(26)} "\
              "#{self.colored_summary(summary)}"
        end
      end

      def colored_ticket(ticket, decoration=false)
        "#{Thor::Shell::Color::RED}"\
        "#{ticket}"\
        "#{self.colored_decoration if decoration}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def colored_decoration
        "#{Thor::Shell::Color::BOLD}"\
        "#{Thor::Shell::Color::YELLOW}*"
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

      def api_get(path)
        response = self.client.get self.api_path(path)
        return JSON.parse(response.body)
      end

      def api_post(path, params)
        response = self.client.post self.api_path(path), params
        return JSON.parse(response)
      end

      def api_path(path)
        "#{Jira::Core.url}/rest/api/2/#{path}"
      end

      def mutex
        @mutex ||= Mutex.new
      end

      def client
        self.mutex.synchronize do
          return @client if !@client.nil?
          @client = Faraday.new
          @client.basic_auth(Jira::Core.username, Jira::Core.password)
          return @client
        end
      end

  end
end
