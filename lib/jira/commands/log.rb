module Jira
  class CLI < Thor

    desc "log", "Logs work against the input ticket"
    def log(ticket=Jira::Core.ticket)
      time_spent = self.io.ask("Time spent on #{ticket}")
      self.api.post("issue/#{ticket}/worklog", { timeSpent: time_spent }) do |json|
        puts "Successfully logged #{time_spent} on #{ticket}."
      end
    end

    desc "logs", "Lists the worklog of the input ticket"
    def logs(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}/worklog") do |json|
        worklogs = json['worklogs']
        if worklogs.count > 0
          worklogs.each do |worklog|
            author = worklog['author']['displayName']
            time = Time.parse(worklog['updated'])
            time_spent = worklog['timeSpent']

            printf "[%2d]", worklogs.index(worklog)
            puts "  #{Jira::Format.user(author)} @ "\
                 "#{Jira::Format.time(time)}:\n"\
                 "#{Jira::Format.comment(time_spent)}"
          end
        else
          puts "There are no worklogs on ticket #{ticket}"
        end
      end
    end

  end
end
