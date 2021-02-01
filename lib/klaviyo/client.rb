module Klaviyo
  class Client
    BASE_API_URL = 'https://a.klaviyo.com/api'
    V1_API = 'v1'
    V2_API = 'v2'

    HTTP_DELETE = 'delete'
    HTTP_GET = 'get'
    HTTP_POST = 'post'
    HTTP_PUT = 'put'

    ALL = 'all'
    TIMELINE = 'timeline'

    DEFAULT_COUNT = 100
    DEFAULT_PAGE = 0
    DEFAULT_SORT_DESC = 'desc'

    private

    def self.request(method, path, kwargs = {})
      check_private_api_key_exists()
      url = "#{BASE_API_URL}/#{path}"
      connection = Faraday.new(
        url: url,
        headers: {
          'Content-Type' => 'application/json'
      })
      response = connection.send(method) do |req|
        req.body = kwargs[:body].to_json || nil
      end
    end

    def self.public_request(method, path, kwargs = {})
      check_public_api_key_exists()
      params = build_params(kwargs)
      url = "#{BASE_API_URL}/#{path}?#{params}"
      res = Faraday.get(url).body
    end

    def self.v1_request(method, path, kwargs = {})
      defaults = {:page => nil,
                  :count => nil,
                  :since => nil,
                  :sort => nil}
      params = defaults.merge(kwargs)
      query_params = encode_params(params)
      full_url = "#{V1_API}/#{path}?api_key=#{Klaviyo.private_api_key}#{query_params}"
      request(method, full_url)
    end

    # V1 Post requests use x-www-form-urlencoded content instead of JSON
    def self.v1_post_request(path, params = {})
      query_params = encode_params(params)
      path = "/api/#{V1_API}/#{path}"
      connection = Faraday.new(url: BASE_API_URL)
      params.merge!(api_key: Klaviyo.private_api_key)
      response = connection.post(path, params)
    end

    def self.v2_request(method, path, kwargs = {})
      path = "#{V2_API}/#{path}"
      key = {
        "api_key": "#{Klaviyo.private_api_key}"
      }
      data = {}
      data[:body] = key.merge(kwargs)
      request(method, path, data)
    end

    def self.build_params(params)
      "data=#{Base64.encode64(JSON.generate(params)).gsub(/\n/,'')}"
    end

    def self.check_required_args(kwargs)
      if kwargs[:email].to_s.empty? and kwargs[:phone_number].to_s.empty? and kwargs[:id].to_s.empty?
        raise Klaviyo::KlaviyoError.new(REQUIRED_ARG_ERROR)
      else
        return true
      end
    end

    def self.check_private_api_key_exists()
      if !Klaviyo.private_api_key
        raise KlaviyoError.new(NO_PRIVATE_API_KEY_ERROR)
      end
    end

    def self.check_public_api_key_exists()
      if !Klaviyo.public_api_key
        raise KlaviyoError.new(NO_PUBLIC_API_KEY_ERROR)
      end
    end

    def self.encode_params(kwargs)
      kwargs.select!{|k, v| v}
      params = URI.encode_www_form(kwargs)

      if !params.empty?
        return "&#{params}"
      end
    end
  end
end
