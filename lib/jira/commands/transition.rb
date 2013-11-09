module Jira
  class CLI < Thor

    desc "transition", "Transitions the input ticket to the next state"
    def transition(ticket=Jira::Core.ticket)
      json = @api.get("issue/#{ticket}/transitions")

      options = {}
      json['transitions'].each do |transition|
        options[transition['name']] = transition['id']
      end
      options['Cancel'] = nil

      self.cli.choose do |menu|
        menu.index = :number
        menu.index_suffix = ") "
        menu.header = "Transitions Available For #{ticket}"
        menu.prompt = "Select a transition: "
        options.keys.each do |choice|
          menu.choice choice do
            transition_id = options[choice]
            if transition_id.nil?
              puts "No transition was performed on #{ticket}."
            else
              self.api_transition(ticket, transition_id, choice)
            end
          end
        end
      end
    end

    protected

      def api_transition(ticket, transition, description)
        json = @api.post(
          "issue/#{ticket}/transitions",
          { transition: { id: transition } }
        )
        if json.empty?
          puts "Successfully performed transition (#{description}) "\
               "on ticket #{ticket}."
        else
          puts json['errorMessages'].join('. ')
        end
      end

  end
end
