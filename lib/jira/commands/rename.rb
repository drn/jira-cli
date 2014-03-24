module Jira
  class CLI < Thor

    desc "rename", "Updates the summary of the input ticket"
    def rename(ticket=Jira::Core.ticket)
      self.describe(ticket)
      summary = self.io.ask("New ticket summary?")
      if !summary.strip.empty?
        params =  { fields: { summary: summary } }
        self.api.put("issue/#{ticket}", params) do |json|
          puts "Successfully updated ticket #{ticket}'s summary."
        end
      else
        puts "No change made to ticket #{ticket}."
      end
    end

  end
end
