module Jira
  class CLI < Thor

    desc "log", "Logs work against the input ticket"
    def log(ticket=Jira::Core.ticket)
      time_spent = self.io.ask("Time spent on ticket #{ticket}")
      self.api.post("issue/#{ticket}/worklog", { timeSpent: time_spent }) do |json|
        puts "Successfully logged #{time_spent} on ticket #{ticket}."
      end
    end

    desc "logd", "Deletes work against the input ticket"
    def logd(ticket=Jira::Core.ticket)
      logs(ticket) if self.io.agree("List worklogs for ticket #{ticket}")

      index = self.get_type_of_index("worklog", "delete")
      puts "No worklog deleted." and return if index < 0

      self.api.get("issue/#{ticket}/worklog") do |json|
        worklogs = json['worklogs']
        if index < worklogs.count
          id = worklogs[index]['id']
          time_spent = worklogs[index]['timeSpent']
          self.api.delete("issue/#{ticket}/worklog/#{id}") do |json|
            puts "Successfully deleted #{time_spent} on ticket #{ticket}"
            return
          end
        end
      end
      puts "No worklog deleted."
    end

    desc "logs", "Lists work against the input ticket"
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

    desc "logu", "Updates work against the input ticket"
    def logu(ticket=Jira::Core.ticket)
      logs(ticket) if self.io.agree("List worklogs for ticket #{ticket}")

      index = self.get_type_of_index("worklog", "update")
      puts "No worklog updated." and return if index < 0

      time_spent = self.io.ask("Time spent on #{ticket}").strip
      puts "No worklog updated." and return if time_spent.empty?

      self.api.get("issue/#{ticket}/worklog") do |json|
        worklogs = json['worklogs']
        if index < worklogs.count
          id = worklogs[index]['id']
          self.api.put("issue/#{ticket}/worklog/#{id}", { timeSpent: time_spent }) do |json|
            puts "Successfully updated #{time_spent} on ticket #{ticket}."
            return
          end
        end
      end
      puts "No worklog updated."
    end

  end
end
