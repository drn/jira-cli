module Jira
  class CLI < Thor

    desc "new", "Creates a new ticket in JIRA and checks out the git branch"
    def new(ticket = Jira::Core.ticket)
      self.api.get("issue/createmeta") do |meta|
        # determine project
        project = self.select_project(meta)
        break if project.empty?

        # determine issue type
        issue_type = self.select_issue_type(project)
        break if issue_type.nil?

        # determine parent (ticket)
        parent = nil
        parent = ticket if issue_type['subtask']
        break if !parent.nil? and !Jira::Core.ticket?(parent)

        # determine summary and description
        summary = self.io.ask("Summary")
        description = self.io.ask("Description")

        # determine api parameters
        params = {
          fields: {
            project:     { id: project[:id] },
            issuetype:   { id: issue_type['id'] },
            summary:     summary,
            description: description
          }
        }
        params[:fields][:parent] = { key: parent } if !parent.nil?

        # post issue to server
        self.api.post("issue", params) do |json|
          ticket = json['key']
          if self.io.agree("Assign")
            self.assign(ticket)
          end
          if self.io.agree("Create branch")
            `git branch #{ticket} 2> /dev/null`
            if self.io.agree("Check-out branch")
              `git checkout #{ticket} 2> /dev/null`
            end
          end
          return
        end
      end
      puts "No ticket created."
    end

    protected

      #
      # Given the creation metadata, prompts the user for the project to use,
      # then return the project data hash
      #
      # @param json [Hash] creation metadata
      #
      # @return [Hash] selected project's metadata
      #
      def select_project(json)
        projects = {}
        json['projects'].each do |project|
          data = {
            id:     project['id'],
            issues: project['issuetypes']
          }
          projects[project['name']] = data
        end
        projects['Cancel'] = nil
        choice = self.io.choose("Select a project", projects.keys)
        return {} if choice == 'Cancel'
        return projects[choice]
      end

      #
      # Given the project metadata, prompts the user for the issue type to use
      # and returns the selected issue type.
      #
      # @param project_data [Hash] project metadata
      #
      # @return [Hash] selected issue type
      #
      def select_issue_type(project_data)
        issue_types = {}
        project_data[:issues].each do |issue_type|
          issue_types[issue_type['name']] = issue_type
        end
        issue_types['Cancel'] = nil
        choice = self.io.choose("Select an issue type", issue_types.keys)
        return issue_types[choice]
      end

  end
end
