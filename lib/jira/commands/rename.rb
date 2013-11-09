module Jira
  class CLI < Thor

    desc "rename", "Updates the summary of the input ticket"
    def rename(ticket=Jira::Core.ticket)
      self.describe(ticket)
      summary = self.cli.ask("What should the new ticket summary be?")
      if !summary.strip.empty?
        json = @api.put(
          "issue/#{ticket}",
          { fields: { summary: summary } }
        )
        if json['errorMessages'].nil?
          puts "Successfully updated ticket #{ticket}'s summary."
        else
          puts json['errorMessages'].join('. ')
        end
      else
        puts "No change made to ticket #{ticket}."
      end
    end

  end
end
