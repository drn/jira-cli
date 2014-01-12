#!/bin/bash
rm jira-cli-*.gem
gem build jira-cli.gemspec
gem install jira-cli-*.gem --development
