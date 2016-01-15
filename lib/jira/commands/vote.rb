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

    desc "votes", "List the votes of the input ticket"
    def votes(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}/votes") do |json|
        voters = json['voters']
        if voters.count > 0
          voters.each do |voter|
            displayName = voter['displayName']

            printf "[%2d]", voters.index(voter)
            puts "  #{Jira::Format.user(displayName)}"
          end
        else
          puts "There are no votes on ticket #{ticket}."
        end
      end
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
