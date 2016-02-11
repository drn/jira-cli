module Jira
  class CLI < Thor

    desc "sprint", "Lists sprint info"
    def sprint
      Command::Sprint.new.run
    end

  end

  module Command
    class Sprint < Base

      def run
        return if rapid_view.empty?
        return if no_sprints?
        return if sprint.empty?
        render_table(
          [ 'Sprint', 'State' ],
          [ [ info['sprint']['name'], info['sprint']['state'] ] ]
        )
      end

    private

      def no_sprints?
        if sprints.empty?
          puts "The #{rapid_view['name']} board has no sprints."
          return true
        end
        false
      end

      def info
        @info ||= sprint_api.sprint(rapid_view['id'], sprint['id'])
      end

      def sprint
        @sprint ||= sprints[
          io.select("Select a sprint:", sprints.keys[-10..-1])
        ]
      end

      def sprints
        @sprints ||= (
          sprints = {}
          sprint_api.sprints(rapid_view['id'])['sprints'].each do |sprint|
            sprints[sprint['name']] = {
              'id'   => sprint['id'],
              'name' => sprint['name']
            }
          end
          sprints
        )
      end

      def rapid_view
        keys = rapid_views.keys
        return '' if keys.empty?
        @rapid_view ||= rapid_views[
          io.select("Select a rapid view:", keys)
        ]
      end

      def rapid_views
        @rapid_views ||= (
          rapid_views = {}
          sprint_api.rapid_views.each do |rapid_view|
            rapid_views[rapid_view['name']] = {
              'id'   => rapid_view['id'],
              'name' => rapid_view['name']
            }
          end
          rapid_views
        )
      end

    end
  end
end
