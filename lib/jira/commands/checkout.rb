module Jira
  class CLI < Thor

    desc "checkout <ticket>", "Checks out a ticket from JIRA in the git branch"
    method_option :remote, aliases: "-r", type: :string, default: nil, lazy_default: "", banner: "REMOTE"
    def checkout(ticket)
      Command::Checkout.new(ticket, options).run
    end

  end

  module Command
    class Checkout < Base

      attr_accessor :ticket, :options

      def initialize(ticket, options)
        self.ticket = ticket
        self.options = options
      end

      def run
        return unless Jira::Core.ticket?(ticket)
        return if metadata.empty?
        unless metadata['errorMessages'].nil?
          on_failure
          return
        end
        unless remote?
          on_failure
          return
        end

        create_branch unless branches.include?(ticket)
        checkout_branch
        reset_branch unless branches.include?(ticket)
        on_success
      end

    private

      def on_success
        puts "Ticket #{ticket} checked out."
      end

      def on_failure
        puts "No ticket checked out."
      end

      def branches
        @branches ||= `git branch --list 2> /dev/null`.split(' ')
        @branches.delete("*")
        @branches
      end

      def create_branch
        `git branch #{ticket} 2> /dev/null`
      end

      def checkout_branch
        `git checkout #{ticket} 2> /dev/null`
      end

      def metadata
        @metadata ||= api.get("issue/#{ticket}")
      end

      def remote
        @remote ||= options['remote'] || io.select('Remote?', remotes)
      end

      def remotes
        @remotes ||= `git remote 2> /dev/null`.split(' ')
      end

      def remote?
        return true if remotes.include?(remote)
        false
      end

      def reset_branch
        `git reset --hard #{remote} 2> /dev/null`
      end

    end
  end
end
