module Jira
  class CLI < Thor

    desc "describe", "Describes the input ticket"
    def describe(ticket=Jira::Core.ticket)
      Command::Describe.new(ticket).run
    end

    desc "all", "Describes all local branches that match JIRA ticketing syntax"
    def all
      # determine which local branches match JIRA ticket syntax
      #   TODO - move to Jira::Git
      tickets = {
        current: nil,
        others: []
      }
      branches = `git branch`.strip.split("\n")
      branches.each do |branch|
        ticket = branch.delete('*').strip
        if Jira::Core.ticket?(ticket, false)
          if branch.include?('*')
            tickets[:current] = ticket
          else
            tickets[:others] << ticket
          end
        end
      end


      # asynchronously fetch and describe tickets
      output = ""
      threads = []
      if !tickets[:current].nil?
        threads << Thread.new{ puts description(tickets[:current], true) }
      end
      mutex = Mutex.new
      tickets[:others].each do |ticket|
        threads << Thread.new do
          out = description(ticket) + "\n"
          if !out.strip.empty?
            mutex.synchronize{ output << out }
          end
        end
      end
      threads.each{ |thread| thread.join }
      puts output if !output.empty?
    end

    protected

      #
      # Returns a formatted description of the input ticket
      #
      # @param ticket [String] the ticket to describe
      # @param star [Boolean] if true, adds a * indicator
      #
      # @return [String] formatted summary string
      #
      def description(ticket, star=false, verbose=false, describe=false)
        self.api.get("issue/#{ticket}", nil, verbose) do |json|
          summary = json['fields']['summary']
          status = json['fields']['status']['name']
          assignee = "nil"
          if json['fields'].has_key?("assignee")
            if !json['fields']['assignee'].nil?
              assignee = json['fields']['assignee']['name']
            end
          end
          description = describe ? "\n" + json['fields']['description'].to_s : ""

          return Jira::Format.ticket(ticket) +
                (star ? Jira::Format.star : " ") + "  \t" +
                ("(" + Jira::Format.user(assignee) + ")").ljust(20) +
                Jira::Format.status(status).ljust(26) +
                Jira::Format.summary(summary) +
                description
        end
        return ""
      end

  end

  module Command
    class Describe < Base

      attr_accessor :ticket

      def initialize(ticket)
        self.ticket = ticket
      end

      def run
        return if json.empty?
        return if errored?
        render_table(header, [row])
      end

      def header
        [ 'Ticket', 'Assignee', 'Status', 'Summary' ]
      end

      def row
        [ ticket, assignee, status, summary ]
      end

      def errored?
        return false if errors.empty?
        puts errors
        true
      end

      def errors
        @errors ||= (json['errorMessages'] || []).join('. ')
      end

      def assignee
        (fields['assignee'] || {})['name'] || 'Unassigned'
      end

      def status
        (fields['status'] || {})['name'] || 'Unknown'
      end

      def summary
        json['fields']['summary']
      end

      def fields
        json['fields'] || {}
      end

      def json
        @json ||= api.get "issue/#{ticket}"
      end

    end
  end
end
