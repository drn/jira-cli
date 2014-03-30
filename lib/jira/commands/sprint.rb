module Jira
  class CLI < Thor

    desc "sprint", "Lists all tickets in active sprint"
    def sprint
      # TODO
      self.api(:agile).get(
        'rapid/charts/sprintreport?rapidViewId=17&sprintId=41'
      ) do |response|
        groups = {}

        parser = ->(issue){
          assignee = issue['assignee']
          status = issue['statusName']
          groups[assignee] ||= {}
          groups[assignee][status] ||= []
          groups[assignee][status] << {
            ticket:  issue['key'],
            summary: issue['summary']
          }
        }

        response['contents']['completedIssues'].each{|issue| parser.call(issue)}
        response['contents']['incompletedIssues'].each{|issue| parser.call(issue)}

        groups.each do |user, status_groups|
          puts user
          status_groups.each do |status, tickets|
            puts "  " + status
            puts "    " + tickets.map{|info| info[:ticket] }.join(' ')
          end
        end
      end
    end

  end
end
