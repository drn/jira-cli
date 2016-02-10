module Jira
  class CLI < Thor

    include Thor::Actions

    protected

      def io
        @io ||= TTY::Prompt.new
      end

  end
end

class String

  def from_json
    JSON.parse(self) rescue {}
  end

  def periodize
    self.strip[-1] == "." ? self : self + "."
  end

end
