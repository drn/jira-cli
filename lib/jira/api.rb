module Jira
  class API

    TYPES = [
      :rest,
      :agile
    ].freeze

    ENDPOINTS = {
      rest:  'rest/api/2',
      agile: 'rest/greenhopper/latest'
    }.freeze

    #
    # Initialize Jira::API
    #
    # @param type [Symbol]
    #
    def initialize(type)
      @type = type
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
        # @yield(Hash) yields to a success block
        #
        # @return [JSON] parased API response
        #
        [:get, :post, :put].each do |method|
          self.class.send(:define_method, method) do |path, params=nil, verbose=true, &block|
            params = params.to_json if !params.nil?
            response = @client.send(
              method,
              self.endpoint(path),
              params,
              self.headers
            )
            json = response.body.to_s.from_json
            if self.errorless?(json, verbose)
              block.call(json)
            end
          end
        end
      end

      #
      # If any, outputs all API errors described by the input JSON
      #
      # @param json [Hash] API response JSON
      # @param verbose [Boolean] true if errors should be output
      #
      # @return [Boolean] true if no errors exist
      #
      def errorless?(json, verbose=true)
        errors = json['errorMessages']
        if !errors.nil?
          puts errors.join('. ') if verbose
          return false
        end
        return true
      end

      #
      # Returns the full JIRA REST API endpoint
      #
      # @param path [String] API path
      #
      # @return [String] API endpoint
      #
      def endpoint(path)
        "#{Jira::Core.url}/#{ENDPOINTS[@type]}/#{path}"
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
