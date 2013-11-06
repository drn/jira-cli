module Jira
  class Format
    class << self

      def star
        "#{Thor::Shell::Color::BOLD}"\
        "#{Thor::Shell::Color::YELLOW}"\
        "*"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def ticket(ticket)
        "#{Thor::Shell::Color::RED}"\
        "#{ticket}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

      def status(status)
        "["\
        "#{Thor::Shell::Color::BLUE}"\
        "#{status}"\
        "#{Thor::Shell::Color::CLEAR}"\
        "]".center(26)
      end

      def summary(summary)
        "#{Thor::Shell::Color::BOLD}"\
        "#{Thor::Shell::Color::WHITE}"\
        "#{summary}"\
        "#{Thor::Shell::Color::CLEAR}"
      end

    end
  end
end
