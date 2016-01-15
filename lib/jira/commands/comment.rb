module Jira
  class CLI < Thor

    desc "comment", "Add a comment to the input ticket"
    def comment(ticket=Jira::Core.ticket)
      comment = self.get_comment_body(ticket)
      puts "No comment posted." and return if comment.empty?

      self.api.post("issue/#{ticket}/comment", { body: comment }) do |json|
        puts "Successfully posted your comment."
        return
      end
      puts "No comment posted."
    end

    desc "commentd", "Delete a comment to the input ticket"
    def commentd(ticket=Jira::Core.ticket)
      comments(ticket) if self.io.agree("List comments for ticket #{ticket}")

      index = self.get_type_of_index("comment", "delete")
      puts "No comment deleted." and return if index < 0

      self.api.get("issue/#{ticket}") do |json|
        comments = json['fields']['comment']['comments']
        if index < comments.count
          id = comments[index]['id']
          self.api.delete("issue/#{ticket}/comment/#{id}") do |json|
            puts "Successfully deleted your comment."
            return
          end
        end
      end
      puts "No comment deleted."
    end

    desc "comments", "Lists the comments of the input ticket"
    def comments(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}") do |json|
        comments = json['fields']['comment']['comments']
        if comments.count > 0
          comments.each do |comment|
            author = comment['author']['displayName']
            time = Time.parse(comment['updated'])
            body = comment['body']

            printf "[%2d]", comments.index(comment)
            puts "  #{Jira::Format.user(author)} @ "\
                 "#{Jira::Format.time(time)}:\n"\
                 "#{Jira::Format.comment(body)}"
          end
        else
          puts "There are no comments on ticket #{ticket}."
        end
      end
    end

    desc "commentu", "Update a comment to the input ticket"
    def commentu(ticket=Jira::Core.ticket)
      comments(ticket) if self.io.agree("List comments for ticket #{ticket}")

      index = self.get_type_of_index("comment", "update")
      puts "No comment updated." and return if index < 0

      comment = self.get_comment_body(ticket)
      puts "No comment updated." and return if comment.empty?

      self.api.get("issue/#{ticket}") do |json|
        comments = json['fields']['comment']['comments']
        id = comments[index]['id']
        self.api.put("issue/#{ticket}/comment/#{id}", { body: comment }) do |json|
          puts "Successfully updated your comment."
          return
        end
      end
      puts "No comment updated."
    end

    protected

      #
      # Prompts the user for a comment body, strips it, then
      # returns a substituted version of it
      #
      # @return comment [String] asked comment body
      #
      def get_comment_body(ticket)
        comment = self.io.ask("Leave a comment for ticket #{ticket}").strip
        temp = comment.gsub(/\@[a-zA-Z]+/,'[~\0]')
        temp = comment if temp.nil?
        temp = temp.gsub('[~@','[~')
        comment = temp if !temp.nil?
        comment
      end

  end
end
