module Jira
  class API

    #
    # Initialize Jira::API
    #
    def initialize
      @client = Faraday.new
      @client.basic_auth(Jira::Core.username, Jira::Core.password)
    end

    #
    # Issue an API GET request and return parsed JSON
    #
    # @param path [String] API path
    #
    # @return [JSON] parsed API response
    #
    def get(path)
      response = @client.get(self.endpoint(path))
      JSON.parse(response.body)
    end

    #
    # Issue an API POST request and return parsed JSON
    #
    # @param path [String] API path
    # @param params [Hash] params to post
    #
    # @return [JSON] parsed API response
    #
    def post(path, params)
      response = @client.post(self.endpoint(path), params)
      JSON.parse(response.body)
    end

    protected

      #
      # Returns the full JIRA REST API endpoint
      #
      # @param path [String] API path
      #
      # @return [String] API endpoint
      #
      def endpoint(path)
        "#{Jira::Core.url}/rest/api/2/#{path}"
      end

  end
end
