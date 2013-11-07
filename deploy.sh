#!/bin/bash
rm jira-cli-*.gem
gem build jira-cli.gemspec
gem push jira-cli-*.gem
