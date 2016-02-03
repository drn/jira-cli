module Jira
  class SprintAPI

    def sprint(rapid_view_id, sprint_id)
      response = client.get(
        'rapid/charts/sprintreport',
        rapidViewId: rapid_view_id,
        sprintId:    sprint_id
      )
      return response.body if response.success?
      {}
    end

    def sprints(rapid_view_id)
      response = client.get("sprintquery/#{rapid_view_id}")
      return response.body if response.success?
      {}
    end

    def rapid_views
      response = client.get("rapidview")
      return response.body['views'] if response.success?
      []
    end

  private

    def client
      @client ||= Faraday.new(endpoint) do |faraday|
        faraday.request  :basic_auth, Jira::Core.username, Jira::Core.password
        faraday.request  :json
        faraday.response :json
        faraday.adapter  :net_http
      end
    end

    def endpoint
      "#{Jira::Core.url}/rest/greenhopper/latest"
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

  end
end
