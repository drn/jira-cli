module Jira
  class CLI < Thor

    desc "comment", "Add a comment to the input ticket"
    def comment(ticket=nil)
      ticket ||= `git rev-parse --abbrev-ref HEAD`.strip
      comment = self.cli.ask("Leave a comment for ticket #{ticket}:")
      if comment.strip.empty?
        puts "No comment posted."
      else
        json = @api.post("issue/#{ticket}/comment", { body: comment }.to_json)
        if json['errorMessages'].nil?
          puts "Successfully posted your comment."
        else
          puts json['errorMessages'].first
        end
      end
    end

    desc "comments", "Lists the comments of the input ticket"
    def comments(ticket=nil)
      ticket ||= `git rev-parse --abbrev-ref HEAD`.strip
      json = @api.get("issue/#{ticket}")
      if json['errorMessages'].nil?

        comments = json['fields']['comment']['comments']
        if comments.count > 0
          comments.each do |comment|
            author = comment['author']['displayName']
            time = Time.parse(comment['created'])
            body = comment['body']

            puts "#{Jira::Format.author(author)} @ "\
                 "#{Jira::Format.time(time)}:\n"\
                 "#{Jira::Format.comment(body)}"
          end
        else
          puts "There are no comments on issue #{ticket}."
        end
      else
        puts json['errorMessages'].first
      end
    end

  end
end
