module Jira
  class CLI < Thor

    desc "log", "Logs work against the input ticket"
    def log(ticket=Jira::Core.ticket)
      time_spent = self.io.ask("Time spent on #{ticket}")
      self.api.post("issue/#{ticket}/worklog", { timeSpent: time_spent }) do |json|
        puts "Successfully logged #{time_spent} on #{ticket}."
      end
    end

  end
end
