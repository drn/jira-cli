require 'jira/commands/vote/add'
require 'jira/commands/vote/delete'
require 'jira/commands/vote/list'

module Jira
  class CLI < Thor

    desc 'vote <command>', 'Commands for voting operations in JIRA'
    subcommand 'vote', Vote

  end
end
