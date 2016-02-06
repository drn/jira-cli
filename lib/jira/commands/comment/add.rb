module Jira
  class Comment < Thor

    desc 'add', 'Add a comment to the input ticket'
    def add(ticket=Jira::Core.ticket)
      Command::Comment::Add.new(ticket).run
    end

  end

  module Command
    module Comment
      class Add < Base

        attr_accessor :ticket

        def initialize(ticket)
          self.ticket = ticket
        end

        def run
          return if body.empty?
          api.post "issue/#{ticket}/comment",
            params:  params,
            success: on_success,
            failure: on_failure
        end

      private

        def params
          { body: body }
        end

        def on_success
          ->{ puts "Successfully posted your comment." }
        end

        def on_failure
          ->{ puts "No comment posted." }
        end

      end
    end
  end
end
