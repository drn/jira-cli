module Jira
  class Comment < Thor

    desc 'update', 'Update a comment to the input ticket'
    def update(ticket=Jira::Core.ticket)
      Command::Comment::Update.new(ticket).run
    end

  end

  module Command
    module Comment
      class Update < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return unless comments?
          api.patch endpoint,
            params:  params,
            success: on_success,
            failure: on_failure
        end

      private

        def params
          { body: body }
        end

        def comments?
          if json.empty?
            puts "Ticket #{ticket} has no comments."
            return false
          end
          true
        end

        def endpoint
          "issue/#{ticket}/comment/#{to_update['id']}"
        end

        def on_success
          ->{ puts "Successfully updated comment originally from #{to_update['updateAuthor']['displayName']}." }
        end

        def on_failure
          ->{ puts "No comment updated." }
        end

        def to_update
          @to_update ||= comments[
            io.select("Select a comment to update:", comments.keys)
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
          "#{author} @ #{updated_at}: #{body}"
        end

        def json
          @json ||= api.get("issue/#{ticket}/comment")['comments']
        end

      end
    end
  end
end
