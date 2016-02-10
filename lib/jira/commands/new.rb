module Jira
  class CLI < Thor

    desc "new", "Creates a new ticket in JIRA and checks out the git branch"
    def new
      Command::New.new.run
    end

  end

  module Command
    class New < Base

      def run
        return if metadata.empty?
        return if project.empty?
        return if project_metadata.empty?
        components # Select components if any after a project
        return if issue_type.empty?
        return if assign_parent? && parent.empty?
        return if summary.empty?
        return if description.empty?

        api.post 'issue',
          params: params,
          success: on_success,
          failure: on_failure
      end

    private

      attr_accessor :ticket

      def params
        {
          fields: {
            project:     { id: project['id'] },
            issuetype:   { id: issue_type['id'] },
            summary:     summary,
            description: description,
            parent:      @parent.nil? ? {} : { key: @parent },
            components:  @components.nil? ? [] : @components
          }
        }
      end

      def on_success
        ->(json) do
          self.ticket = json['key']
          io.say("Ticket #{ticket} created.")
          assign?
          create_branch? && checkout_branch?
        end
      end

      def assign?
        Command::Assign.new(ticket).run if io.yes?('Assign?')
      end

      def create_branch?
        return false if io.no?("Create branch?")
        `git branch #{ticket} 2> /dev/null`
        true
      end

      def checkout_branch?
        return false if io.no?("Check-out branch?")
        `git checkout #{ticket} 2> /dev/null`
        true
      end

      def on_failure
        ->{ puts "No ticket created." }
      end

      def metadata
        # TODO - {} on 200 but jira error
        @metadata ||= api.get('issue/createmeta')
      end

      def project
        @project ||= projects[
          io.select("Select a project:", projects.keys)
        ]
      end

      def projects
        @projects ||= (
          projects = {}
          metadata['projects'].each do |project|
            projects[project['name']] = {
              'id'     => project['id'],
              'issues' => project['issuetypes']
            }
          end
          projects
        )
      end

      def project_metadata
        id = project['id']
        @project_metadata ||= api.get("project/#{id}")
      end

      def components
        @components ||= (
          components = {}
          project_metadata['components'].each do |component|
            components[component['name']] = { 'id' => component['id'] }
          end
          unless components.empty?
            io.multi_select("Select component(s):", components)
          end
        )
      end

      def assign_parent?
        return false unless issue_type['subtask']
        return false if io.no?('Set parent of subtask?')
        true
      end

      def parent
        @parent ||= io.ask('Subtask parent:', default: Jira::Core.ticket)
      end

      def issue_type
        @issue_type ||= issue_types[
          io.select("Select an issue type:", issue_types.keys)
        ]
      end

      def issue_types
        @issue_types ||= (
          issue_types = {}
          project['issues'].each do |issue_type|
            issue_types[issue_type['name']] = issue_type
          end
          issue_types
        )
      end

      def summary
        @summary ||= io.ask("Summary:")
      end

      def description
        @description ||= io.ask("Description:")
      end

    end
  end
end
