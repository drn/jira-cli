require 'spec_helper.rb'
require 'jira/core'

describe Jira::Core do

  context "setup" do
    it "should call memoization functions" do
      expect(Jira::Core).to receive(:url).once
      expect(Jira::Core).to receive(:auth).once
      Jira::Core.setup
    end
  end

  context "url" do
    it "should memoize " do
      expect(Jira::Core.instance_variable_get(:@url)).to be(nil)
      Jira::Core.stub(:read){ 'url' }
      expect(Jira::Core.url).to be_an_instance_of(String)
      expect(Jira::Core.instance_variable_get(:@url)).to_not be(nil)
    end
  end

end

