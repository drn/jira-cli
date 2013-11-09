# dependencies
require 'thor'
# core logic
require 'jira/constants'
require 'jira/core'
require 'jira/api'
require 'jira/format'
require 'jira/mixins'
# include jira/commands/*
Dir.glob(
  File.dirname(File.absolute_path(__FILE__)) + '/jira/commands/*',
  &method(:require)
)

module Jira
  class CLI < Thor

    def initialize(args=[], options={}, config={})
      super
      Jira::Core.setup
      self.api
    end

  end
end
