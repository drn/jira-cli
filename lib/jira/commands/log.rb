require 'jira/commands/log/add'
require 'jira/commands/log/delete'
require 'jira/commands/log/list'
require 'jira/commands/log/update'

module Jira
  class CLI < Thor

    desc 'log <command>', 'Commands for logging operations in JIRA'
    subcommand 'log', Log

  end
end
