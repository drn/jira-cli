# JIRA CLI [![Gem Version](https://badge.fury.io/rb/jira-cli.png)](http://badge.fury.io/rb/jira-cli)

Control JIRA from your terminal

* * *

[![Circle CI](https://circleci.com/gh/ruby-jira/jira-cli.svg?style=svg)](https://circleci.com/gh/ruby-jira/jira-cli)
[![Code Climate](https://codeclimate.com/github/ruby-jira/jira-cli.png)](https://codeclimate.com/github/ruby-jira/jira-cli)

### Available Commands

    jira assign             # Assign a ticket to a user
    jira attachments        # View ticket attachments
    jira comment <command>  # Commands for comment operations in JIRA
    jira delete             # Deletes a ticket
    jira describe           # Describes the input ticket
    jira help [COMMAND]     # Describe available commands or one specific command
    jira install            # Guides the user through JIRA CLI installation
    jira link               # Creates a link between two tickets in JIRA
    jira log <command>      # Commands for logging operations in JIRA
    jira new                # Creates a new ticket in JIRA
    jira rename             # Updates the summary of the input ticket
    jira sprint             # Lists sprint info
    jira tickets [jql]      # List the tickets of the input username (or jql)
    jira transition         # Transitions the input ticket to the next state
    jira version            # Displays the version
    jira vote <command>     # Commands for voting operations in JIRA
    jira watch <command>    # Commands for watching tickets in JIRA

### Gem Installation

Rubygems:

    gem install jira-cli

Manually:

    git clone git@github.com:ruby-jira/jira-cli.git
    cd jira-cli
    ./scripts/install

### License

(The MIT License)

Copyright © 2014 Darren Cheng

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
