require_relative 'log/add'
require_relative 'log/delete'
require_relative 'log/list'
require_relative 'log/update'

module Jira
  class CLI < Thor

    desc 'log', 'log subcommands'
    subcommand 'log', Log

  end
end
