module Jira
  class CLI < Thor

    desc "watch", "Watch against the input ticket"
    def watch(ticket=Jira::Core.ticket)
      self.api.post("issue/#{ticket}/watchers", Jira::Core.username) do |json|
        puts "Successfully watched against ticket #{ticket}"
        return
      end
      puts "No watch."
    end

    desc "watchers", "List the watchers of the input ticket"
    def watchers(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}/watchers") do |json|
        watchers = json['watchers']
        if watchers.count > 0
          watchers.each do |watcher|
            displayName = watcher['displayName']

            printf "[%2d]", watchers.index(watcher)
            puts "  #{Jira::Format.user(displayName)}"
          end
        else
          puts "There are no watchers on ticket #{ticket}."
        end
      end
    end

    desc "unwatch", "Unwatch against the input ticket"
    def unwatch(ticket=Jira::Core.ticket)
      username = Jira::Core.username
      self.api.delete("issue/#{ticket}/watchers?username=#{username}") do |json|
        puts "Successfully unwatched against ticket #{ticket}"
        return
      end
      puts "No unwatch."
    end

  end
end
