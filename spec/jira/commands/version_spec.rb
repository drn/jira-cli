require 'spec_helper'

describe 'version command' do

  let(:cli) { Jira::CLI.new }
  let(:version) { Jira::VERSION }

  it 'outputs version' do
    expect { cli.version }.to output(/jira #{version}/).to_stdout
  end

end
