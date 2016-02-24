module Jira
  class Comment < Thor

    desc 'add', 'Add a comment to the input ticket'
    method_option :text, aliases: "-t", type: :string, default: nil, lazy_default: "", banner: "TEXT"
    def add(ticket=Jira::Core.ticket)
      Command::Comment::Add.new(ticket, options).run
    end

  end

  module Command
    module Comment
      class Add < Base

        attr_accessor :ticket, :options

        def initialize(ticket, options)
          self.ticket = ticket
          self.options = options
        end

        def run
          return if text.empty?
          api.post "issue/#{ticket}/comment",
            params:  params,
            success: on_success,
            failure: on_failure
        end

      private

        def params
          { body: text }
        end

        def text
          body(options['text'])
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
