module Jira
  class API

    #
    # Initialize Jira::API
    #
    def initialize
      @client = Faraday.new
      @client.basic_auth(Jira::Core.username, Jira::Core.password)

      self.define_actions
    end

    protected

      #
      # Defines the API GET, POST, PUT interaction methods
      #
      def define_actions
        #
        # def method(path, params={})
        #
        # Issue an API GET, POST, or PUT request and return parse JSON
        #
        # @param path [String] API path
        # @param params [Hash] params to send
        #
        # @return [JSON] parased API response
        #
        [:get, :post, :put].each do |method|
          self.class.send(:define_method, method) do |path, params=nil|
            params = params.to_json if !params.nil?
            response = @client.send(
              method,
              self.endpoint(path),
              params,
              self.headers
            )
            return response.body.to_s.from_json
          end
        end
      end

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
