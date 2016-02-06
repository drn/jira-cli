require 'jira/commands/comment/add'
require 'jira/commands/comment/delete'
require 'jira/commands/comment/list'
require 'jira/commands/comment/update'

module Jira
  class CLI < Thor

    desc 'comment <command>', 'Commands for comment operations in JIRA'
    subcommand 'comment', Comment

  end

end
