# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jira/version"

Gem::Specification.new do |s|
  s.name        = 'jira-cli'
  s.version     = Jira::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Darren Lin Cheng']
  s.email       = 'darren@thanx.com'
  s.homepage    = 'http://rubygems.org/gems/jira-cli'
  s.summary     = 'JIRA CLI'
  s.description = 'CLI used to manage JIRA workflows leveraging git'
  s.license     = 'MIT'

  s.files       = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables = ['jira']
  s.require_paths = ['lib']

  s.add_dependency 'thor', '~> 0.18.1'
end
