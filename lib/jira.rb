require 'thor'
require 'fileutils'
require 'jira/constants'
require 'jira/core'
require 'jira/mixins'
require 'jira/version'
require 'jira/install'
require 'jira/lookup'

module Jira
  class CLI < Thor

    def initialize(args=[], options={}, config={})
      super
      Jira::Core.setup
    end

  end
end
