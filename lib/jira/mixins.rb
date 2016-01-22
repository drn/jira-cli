module Jira
  class CLI < Thor

    require 'json'
    require 'faraday'
    require 'inifile'
    require 'tty-prompt'
    include Thor::Actions

    protected

      def io
        @io ||= TTY::Prompt.new
      end

      #
      # @param [Symbol]
      #
      # @return [Jira::API] Jira API class
      #
      def api(type=:rest)
        key = "@api_#{type}"
        klass = self.instance_variable_get(key)
        if klass.nil?
          klass = Jira::API.new(type)
          self.instance_variable_set(key, klass)
        end
        return klass
      end

      #
      # Prompts the user for a type of index, then returns the
      # it; failure is < 0
      #
      # @return index [Integer] asked type of index
      #
      def get_type_of_index(command, description)
        response = self.io.ask("Index for #{command} to #{description}:").strip
        return -1 if response.empty?
        index = response.to_i
        return -1 if index < 0
        index
      end
  end
end

class String

  def from_json
    JSON.parse(self) rescue {}
  end

  def periodize
    self.strip[-1] == "." ? self : self + "."
  end

end
