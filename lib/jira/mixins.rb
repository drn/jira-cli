module Jira
  class CLI < Thor

    require 'json'
    require 'faraday'
    require 'pry-remote' rescue nil
    require 'inquirer'
    include Thor::Actions

    protected

      #
      # @return [Highline] HighLine instance for handling input
      #
      def io
        @io ||= Jira::IO.new
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
