module Jira
  class CLI < Thor

    desc "vote", "Vote against the input ticket"
    def vote(ticket=Jira::Core.ticket)
      self.api.post("issue/#{ticket}/votes", Jira::Core.username) do |json|
        puts "Successfully voted against ticket #{ticket}"
        return
      end
      puts "No vote."
    end

    desc "unvote", "Unvote against the input ticket"
    def unvote(ticket=Jira::Core.ticket)
      username = Jira::Core.username
      self.api.delete("issue/#{ticket}/votes?username=#{username}") do |json|
        puts "Successfully unvoted against ticket #{ticket}"
        return
      end
      puts "No unvote."
    end

  end
end
