# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jira/constants"

Gem::Specification.new do |s|
  s.name        = 'jira-cli'
  s.version     = Jira::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Darren Lin Cheng']
  s.email       = 'darren@thanx.com'
  s.homepage    = 'https://github.com/darrenli/jira-cli'
  s.summary     = 'JIRA CLI'
  s.description = 'CLI used to manage JIRA workflows leveraging git'
  s.license     = 'MIT'

  s.files       = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables = ['jira']
  s.require_paths = ['lib']

  s.add_dependency 'thor', '~> 0.19.1', '>= 0.19.1'
  s.add_dependency 'faraday', '~> 0.9.0', '>= 0.9.0'
  s.add_dependency 'inquirer', '~> 0.2.0', '>= 0.2.0'
  s.add_development_dependency 'pry-remote', '~> 0.1.7', '>= 0.1.7'
  s.add_development_dependency 'rspec-expectations', '~> 2.14.0', '>= 2.14.0'
  s.add_development_dependency 'rspec', '~> 2.14.1', '>= 2.14.1'
  s.add_development_dependency 'coveralls', '~> 0.7.0', '>= 0.7.0'
end
