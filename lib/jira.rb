# dependencies
require 'thor'
# core logic
require 'jira/constants'
require 'jira/core'
require 'jira/api'
require 'jira/io'
require 'jira/format'
require 'jira/mixins'
require 'jira/exceptions'
# include jira/commands/*
Dir.glob(
  File.dirname(File.absolute_path(__FILE__)) + '/jira/commands/*',
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
