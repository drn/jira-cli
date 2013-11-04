module Jira
  class CLI < Thor

    desc "me", "Displays current branch"
    def me
      %x{git me}
      #say "jira git me"
    end

  end
end
