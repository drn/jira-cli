# JIRA CLI

Ruby gem CLI tool used to manage JIRA workflows leveraging git

* * *

[![Build Status](https://travis-ci.org/darrenli/jira-cli.png?branch=master)](https://travis-ci.org/darrenli/jira-cli)
[![Coverage Status](https://coveralls.io/repos/darrenli/jira-cli/badge.png)](https://coveralls.io/r/darrenli/jira-cli)
[![Dependency Status](https://gemnasium.com/darrenli/jira-cli.png)](https://gemnasium.com/darrenli/jira-cli)
[![Code Climate](https://codeclimate.com/github/darrenli/jira-cli.png)](https://codeclimate.com/github/darrenli/jira-cli)
[![Gem Version](https://badge.fury.io/rb/jira-cli.png)](http://badge.fury.io/rb/jira-cli)

## Disclaimer

This tool is in very early alpha and its architecture and commands
are expected to change drastically. Please only use this tool for testing
purposes.

## Gem Installation

Rubygems:

    gem install jira-cli

Manually:

    git clone git@github.com:darrenli/jira-cli.git
    cd jira-cli
    ./install

## Project Installation

In order to use this tool, you'll need to run the installation script in the
git repository that you're managing via JIRA.

    cd path/to/jira/repo
    jira install

Note: Authentication files are expected to drastically change. Currently, they
are completely unencrypted. Use are your own risk... (see disclaimer above)
