module Jira
  class CLI < Thor

    desc "attachments", "View ticket attachments"
    def attachments(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}") do |json|
        attachments=json['fields']['attachment']
        if attachments.count > 0
          attachments.each do |attachment|
            name=attachment['filename']
            url=attachment['content']

            puts "#{Jira::Format.user(name)} #{url}"
          end
        else
          puts "No attachments found"
        end
      end
    end

  end
end
