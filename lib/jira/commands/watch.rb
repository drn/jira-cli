require 'jira/commands/watch/add'
require 'jira/commands/watch/delete'
require 'jira/commands/watch/list'

module Jira
  class CLI < Thor

    desc 'watch <command>', 'Commands for watching tickets in JIRA'
    subcommand 'watch', Watch

  end
end
