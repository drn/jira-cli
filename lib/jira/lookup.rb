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

      def output_summary(ticket, decorate=false)
        json = @api.get("issue/#{ticket}")
        summary = json['fields']['summary']
        status = json['fields']['status']['name']
        say Jira::Format.ticket(ticket) +
            (decorate ? Jira::Format.star : " ") +
            Jira::Format.status(status) +
            Jira::Format.summary(summary)
      end

  end
end
