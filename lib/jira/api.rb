module Jira
  class API

    def get(path, options={})
      response = client.get(path, options[:params] || {}, headers)
      process(response, options)
    end

    def post(path, options={})
      response = client.post(path, options[:params] || {}, headers)
      process(response, options)
    end

    def patch(path, options={})
      response = client.put(path, options[:params] || {}, headers)
      process(response, options)
    end

    def delete(path, options={})
      response = client.delete(path, options[:params] || {}, headers)
      process(response, options)
    end

  protected

    def process(response, options)
      raise UnauthorizedException if response.status == 401
      body = response.body || {}
      json = (body if body.class == Hash) || {}
      if response.success? && json['errorMessages'].nil?
        respond_to(options[:success], body)
      else
        puts json['errorMessages'].join('. ') unless json['errorMessages'].nil?
        respond_to(options[:failure], body)
      end
      body
    end

    def respond_to(block, body)
      return if block.nil?
      case block.arity
      when 0
        block.call
      when 1
        block.call(body)
      end
    end

    def client
      @client ||= Faraday.new(endpoint) do |faraday|
        faraday.request  :basic_auth, Jira::Core.username, Jira::Core.password unless Jira::Core.password.nil?
        faraday.request  :token_auth, Jira::Core.token unless Jira::Core.token.nil?
        faraday.request  :json
        faraday.response :json
        faraday.adapter  :net_http
      end
    end

    def endpoint
      "#{Jira::Core.url}/rest/api/2"
    end

    def headers
      { 'Content-Type' => 'application/json' }.merge(cookies)
    end

    def cookies
      cookie = Jira::Core.cookie
      unless cookie.empty?
        return { 'cookie' => "#{cookie[:name]}=#{cookie[:value]}" }
      end
      {}
    end

  end
end
