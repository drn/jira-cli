module Jira
  class IO

    def ask(prompt)
      Ask.input(prompt)
    end

    def agree(prompt)
      Ask.confirm(prompt, default: false)
    end

    def choose(prompt, options)
      options[Ask.list(prompt, options)]
    end

  end
end
