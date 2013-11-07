# dependencies
require 'thor'
# core logic
require 'jira/constants'
require 'jira/core'
require 'jira/api'
require 'jira/format'
require 'jira/mixins'
# command logic
require 'jira/version'
require 'jira/install'
require 'jira/describe'
require 'jira/comment'

module Jira
  class CLI < Thor

    def initialize(args=[], options={}, config={})
      super
      Jira::Core.setup
      @api = Jira::API.new
    end

  end
end
