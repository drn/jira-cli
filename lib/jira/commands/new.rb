module Jira
  class CLI < Thor

    desc "new", "Creates a new ticket in JIRA and checks out the git branch"
    def new
      self.api.get("issue/createmeta") do |meta|
        # determine project
        project = self.select_project(meta)
        break if project.empty?

        # determine issue type
        issue_type = self.select_issue_type(project)
        return if issue_type.empty?

        # determine summary and description
        summary = self.cli.ask("\nSummary: ")
        description = self.cli.ask("Description:")

        # determine api parameters
        params = {
          fields: {
            project:     { id: project[:id] },
            issuetype:   { id: issue_type },
            summary:     summary,
            description: description
          }
        }

        # post issue to server
        self.api.post("issue", params) do |json|
          ticket = json['key']
          `echo #{Jira::Core.url}/browse/#{ticket} | pbcopy`
          puts "\nTicket #{Jira::Format.ticket(ticket)} created and copied"\
               " to your clipboard."
          if self.cli.agree("Create branch? (yes/no) ")
            `git branch #{ticket} 2> /dev/null`
            if self.cli.agree("Checkout branch? (yes/no) ")
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

        self.cli.choose do |menu|
          menu.index = :number
          menu.index_suffix = ") "
          menu.header = "Select a project to create issue under"
          menu.prompt = "Project: "
          projects.keys.each do |choice|
            menu.choice choice do
              project_data = projects[choice]
              if !project_data.nil?
                return project_data
              end
            end
          end
        end
        return {}
      end

      #
      # Given the project metadata, prompts the user for the issue type to use
      # and returns the selected issue type.
      #
      # @param project_data [Hash] project metadata
      #
      # @return [String] selected issue type
      #
      def select_issue_type(project_data)
        issue_types = {}
        project_data[:issues].each do |issue_type|
          issue_types[issue_type['name']] = issue_type['id']
        end
        issue_types['Cancel'] = nil

        self.cli.choose do |menu|
          menu.index = :number
          menu.index_suffix = ") "
          menu.header = "\nSelect an issue type"
          menu.prompt = "Issue type: "
          issue_types.keys.each do |choice|
            menu.choice choice do
              issue_type_id = issue_types[choice]
              if !issue_type_id.nil?
                return issue_type_id
              end
            end
          end
        end
        return ""
      end

  end
end
