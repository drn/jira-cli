module Jira
  class CLI < Thor

    desc "log", "Logs work against the input ticket"
    def log(ticket=Jira::Core.ticket)
      time_spent = self.cli.ask("Time spent on #{ticket}: ")
      json = @api.post("issue/#{ticket}/worklog", { timeSpent: time_spent })
      if json['errorMessages'].nil?
        puts "Successfully logged #{time_spent} on #{ticket}."
      else
        puts json['errorMessages'].join('. ')
      end
    end

  end
end
