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
    def get(path, params={})
      response = @client.get(self.endpoint(path), params, self.headers)
      return response.body.to_s.from_json
    end

    #
    # Issue an API POST request and return parsed JSON
    #
    # @param path [String] API path
    # @param params [Hash] params to post
    #
    # @return [JSON] parsed API response
    #
    def post(path, params={})
      response = @client.post(self.endpoint(path), params.to_json, self.headers)
      return response.body.to_s.from_json
    end

    #
    # Issue an API PUT request and return parsed JSON
    #
    # @param path [String] API path
    # @parma params [Hash] params to put
    #
    # @return [JSON] parsed API response
    #
    def put(path, params={})
      response = @client.put(self.endpoint(path), params.to_json, self.headers)
      return response.body.to_s.from_json
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

      #
      # Returns the default API headers
      #
      # @return [Hash] API headers
      #
      def headers
        { 'Content-Type' => 'application/json' }
      end

  end
end
