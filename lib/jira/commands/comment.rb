module Jira
  class CLI < Thor

    desc "comment", "Add a comment to the input ticket"
    def comment(ticket=Jira::Core.ticket)
      comment = self.cli.ask("Leave a comment for ticket #{ticket}:")
      if comment.strip.empty?
        puts "No comment posted."
      else
        json = @api.post("issue/#{ticket}/comment", { body: comment }.to_json)
        if json['errorMessages'].nil?
          puts "Successfully posted your comment."
        else
          puts json['errorMessages'].join('. ')
        end
      end
    end

    desc "comments", "Lists the comments of the input ticket"
    def comments(ticket=Jira::Core.ticket)
      json = @api.get("issue/#{ticket}")
      if json['errorMessages'].nil?
        comments = json['fields']['comment']['comments']
        if comments.count > 0
          comments.each do |comment|
            author = comment['author']['displayName']
            time = Time.parse(comment['created'])
            body = comment['body']

            puts "#{Jira::Format.user(author)} @ "\
                 "#{Jira::Format.time(time)}:\n"\
                 "#{Jira::Format.comment(body)}"
          end
        else
          puts "There are no comments on issue #{ticket}."
        end
      else
        puts json['errorMessages'].join('. ')
      end
    end

  end
end
