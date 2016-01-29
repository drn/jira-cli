# dependencies
require 'thor'
# core logic and commands
Dir.glob(
  File.dirname(File.absolute_path(__FILE__)) + '/jira/**/*.rb',
  &method(:require)
)

module Jira
  class CLI < Thor

  end
end
