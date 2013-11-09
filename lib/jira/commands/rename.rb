module Jira
  class CLI < Thor

    desc "rename", "Updates the summary of the input ticket"
    def rename(ticket=Jira::Core.ticket)
      self.describe(ticket)
      summary = self.cli.ask("What should the new ticket summary be?")
      if !summary.strip.empty?
        params =  { fields: { summary: summary } }
        @api.put("issue/#{ticket}", params) do |json|
          puts "Successfully updated ticket #{ticket}'s summary."
        end
      else
        puts "No change made to ticket #{ticket}."
      end
    end

  end
end
