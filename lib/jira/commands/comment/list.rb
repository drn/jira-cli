module Jira
  class Comment < Thor

    desc 'list', 'Lists the comments of the input ticket'
    def list(ticket=Jira::Core.ticket)
      Command::Comment::List.new(ticket).run
    end

  end

  module Command
    module Comment
      class List < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if comments.nil?

          if comments.empty?
            puts "Ticket #{ticket} has no comments."
            return
          end
          render_table(header, rows)
        end

      private

        attr_accessor :comment

        def header
          [ 'Author', 'Updated At', 'Body' ]
        end

        def rows
          rows = []
          comments.each do |comment|
            self.comment = comment
            rows << row
          end
          rows
        end

        def row
          [ author, updated_at, body ]
        end

        def author
          comment['updateAuthor']['displayName']
        end

        def updated_at
          Jira::Format.time(Time.parse(comment['updated']))
        end

        def body
          body = comment['body'].gsub("\r\n|\r|\n", ";")
          truncate(body, 45)
        end

        def comments
          @comments ||= api.get("issue/#{ticket}/comment")['comments']
        end

      end
    end
  end
end
