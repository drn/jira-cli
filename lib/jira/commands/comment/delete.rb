module Jira
  class Comment < Thor

    desc 'delete', 'Delete a comment to the input ticket'
    def delete(ticket=Jira::Core.ticket)
      Command::Comment::Delete.new(ticket).run
    end

  end

  module Command
    module Comment
      class Delete < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return unless comments?
          api.delete endpoint,
            success: on_success,
            failure: on_failure
        end

      private

        def comments?
          if json.empty?
            puts "Ticket #{ticket} has no comments."
            return false
          end
          true
        end

        def endpoint
          "issue/#{ticket}/comment/#{to_delete['id']}"
        end

        def on_success
          ->{ puts "Successfully deleted comment from #{to_delete['updateAuthor']['displayName']}" }
        end

        def on_failure
          ->{ puts "No comment deleted." }
        end

        def to_delete
          @to_delete ||= comments[
            io.select("Select a comment to delete:", comments.keys)
          ]
        end

        def comments
          @comments ||= (
            comments = {}
            json.each do |comment|
              comments[description_for(comment)] = comment
            end
            comments
          )
        end

        def description_for(comment)
          author = comment['updateAuthor']['displayName']
          updated_at = Jira::Format.time(Time.parse(comment['updated']))
          body = comment['body'].gsub("\r\n|\r|\n", ";")
          truncate("#{author} @ #{updated_at}: #{body}", 160)
        end

        def json
          @json ||= api.get("issue/#{ticket}/comment")['comments']
        end

      end
    end
  end
end
