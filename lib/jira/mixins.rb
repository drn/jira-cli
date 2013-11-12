module Jira
  class CLI < Thor

    require 'highline/import'
    require 'json'
    require 'faraday'
    include Thor::Actions

    protected

      #
      # @return [Highline] HighLine instance for handling input
      #
      def cli
        @highline ||= ::HighLine.new
      end

      #
      # @return [Jira::API] Jira API class
      #
      def api
        @api ||= Jira::API.new
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
