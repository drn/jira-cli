module Jira
  class CLI < Thor

    desc "delete", "Deletes a ticket in JIRA and the git branch"
    method_option :force, type: :boolean, default: false
    def delete(ticket=Jira::Core.ticket)
      force = options[:force]
      self.api.get("issue/#{ticket}") do |json|
        issue_type = json['fields']['issuetype']
        if !issue_type['subtask']
          if !json['fields']['subtasks'].empty? && !force
            force = self.io.agree("Delete all sub-tasks for ticket #{ticket}")
            puts "No ticket deleted." and return if !force
          end
        end

        self.api.delete("issue/#{ticket}?deleteSubtasks=#{force}") do |json|
          branches = `git branch --list 2> /dev/null`.split(' ')
          branches.delete("*")
          branches.delete("#{ticket}")
          create_branch = self.io.agree("Create branch") if branches.count > 1
          if branches.count == 1 or create_branch
            puts "Creating a new branch."
            new_branch = self.io.ask("Branch").strip
            new_branch.delete!(" ")
            puts "No ticket deleted." and return if new_branch.empty?
            `git branch #{new_branch} 2> /dev/null`
            branches << new_branch
          end
          chosen_branch = self.io.choose("Select a branch", branches)
          `git checkout #{chosen_branch} 2> /dev/null`
          `git branch -D #{ticket} 2> /dev/null`
          return
        end
      end
      puts "No ticket deleted."
    end

  end
end
