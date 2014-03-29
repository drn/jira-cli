# dependencies
require 'thor'
# core logic and commands
Dir.glob(
  File.dirname(File.absolute_path(__FILE__)) + '/jira/**/*.rb',
  &method(:require)
)

module Jira
  class CLI < Thor

    def initialize(args=[], options={}, config={})
      super
      self.suppress{ Jira::Core.setup }
      self.suppress{ self.api }
    end

    protected

      def suppress
        yield
      rescue GitException
      rescue InstallationException
      end

  end
end
