module Jira
  class CLI < Thor

    desc 'new', 'Creates a new ticket'
    method_option :project, aliases: "-p", type: :string, default: nil, banner: "PROJECT"
    method_option :components, aliases: "-c", type: :array, default: nil, lazy_default: [], banner: "COMPONENTS"
    method_option :issuetype, aliases: "-i", type: :string, default: nil, banner: "ISSUETYPE"
    method_option :parent, type: :string, default: nil, lazy_default: "", banner: "PARENT"
    method_option :summary, aliases: "-s", type: :string, default: nil, banner: "SUMMARY"
    method_option :description, aliases: "-d", type: :string, default: nil, lazy_default: "", banner: "DESCRIPTION"
    method_option :assignee, aliases: "-a", type: :string, default: nil, lazy_default: "auto", banner: "ASSIGNEE"
    def new
      Command::New.new(options).run
    end

  end

  module Command
    class New < Base

      attr_accessor :options

      def initialize(options)
        self.options = options
      end

      def run
        return if metadata.empty?
        return if project.nil? || project.empty?
        return if project_metadata.empty?
        components # Select components if any after a project
        return if issue_type.nil? || issue_type.empty?
        return if assign_parent? && parent.empty?
        return if summary.empty?

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
          assign? if options.empty? || !options['assignee'].nil?
        end
      end

      def assign?
        Command::Assign.new(ticket, options).run if !options['assignee'].nil? || io.yes?('Assign?')
      end

      def on_failure
        ->{ puts "No ticket created." }
      end

      def metadata
        # TODO: {} on 200 but jira error
        @metadata ||= api.get('issue/createmeta')
      end

      def project
        @project ||= projects[
          options['project'] || io.select("Select a project:", projects.keys)
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
            if options['components'].nil?
              components = io.multi_select("Select component(s):", components)
            else
              components.select! { |k| options['components'].include?(k) }
              components = components.values
            end
          end
          components.to_a
        )
      end

      def assign_parent?
        return false unless issue_type['subtask']
        return false if options['parent'].nil? && io.no?('Set parent of subtask?')
        true
      end

      def parent
        @parent ||= options['parent'] || io.ask('Subtask parent:')
      end

      def issue_type
        @issue_type ||= issue_types[
            options['issuetype'] || io.select("Select an issue type:", issue_types.keys)
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
        @summary ||= options['summary'] || io.ask("Summary:", default: '')
      end

      def description
        @description ||= (
          description = options['description'] || (io.ask("Description:", default: '') if options['summary'].nil?)
          description ||= ""
        )
      end

    end
  end
end
