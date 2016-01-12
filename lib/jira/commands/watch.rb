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
