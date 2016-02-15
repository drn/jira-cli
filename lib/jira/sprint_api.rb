module Jira
  class SprintAPI < API

    def sprint(rapid_view_id, sprint_id)
      params = {
        rapidViewId: rapid_view_id,
        sprintId:    sprint_id
      }
      json = get('rapid/charts/sprintreport', params: params) || {}
      return json if json['errorMessages'].nil?
      {}
    end

    def sprints(rapid_view_id)
      json = get("sprintquery/#{rapid_view_id}")
      return json if json['errorMessages'].nil?
      {}
    end

    def rapid_views
      json = get("rapidview")
      return json['views'] if json['errorMessages'].nil?
      []
    end

  protected

    def endpoint
      "#{Jira::Core.url}/rest/greenhopper/latest"
    end

  end
end
