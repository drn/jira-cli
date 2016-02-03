# external dependencies
require 'thor'
require 'tty-table'
require 'inifile'
require 'tty-prompt'
require 'json'
require 'faraday'
require 'faraday_middleware'
# internal dependencies
require 'jira/exceptions'
require 'jira/constants'
require 'jira/command'
require 'jira/format'

module Jira
  class CLI < Thor

  end
end
