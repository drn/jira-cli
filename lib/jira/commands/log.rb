module Jira
  class CLI < Thor

    desc "log", "Logs work against the input ticket"
    def log(ticket=Jira::Core.ticket)
      time_spent = self.cli.ask("Time spent on #{ticket}: ")
      json = @api.post("issue/#{ticket}/worklog", { timeSpent: time_spent })
      if @api.errorless?(json)
        puts "Successfully logged #{time_spent} on #{ticket}."
      end
    end

  end
end
