module Jira
  class CLI < Thor

    desc "transition", "Transitions the input ticket to the next state"
    def transition(ticket=Jira::Core.ticket)
      self.api.get("issue/#{ticket}/transitions") do |json|
        options = {}
        json['transitions'].each do |transition|
          options[transition['to']['name']] = transition['id']
        end
        options['Cancel'] = nil

        self.cli.choose do |menu|
          menu.index = :number
          menu.index_suffix = ") "
          menu.header = "Transition #{Jira::Format.ticket(ticket)} to:"
          menu.prompt = "Transition to: "
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
    end

    protected

      def api_transition(ticket, transition, description)
        params = { transition: { id: transition } }
        self.api.post("issue/#{ticket}/transitions", params) do |json|
          puts "Successfully performed transition (#{description}) "\
               "on ticket #{ticket}."
        end
      end

  end
end
