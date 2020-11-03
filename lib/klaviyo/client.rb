module Klaviyo
  class Client
    BASE_API_URL = 'https://a.klaviyo.com/api'
    V1_API = 'V1_API'
    V2_API = 'V2_API'

    HTTP_GET = 'GET'
    HTTP_POST = 'POST'
    HTTP_PUT = 'PUT'
    HTTP_DELETE = 'DELETE'

    ALL = 'all'
    EXCLUSIONS = 'exclusions'
    EXPORT = 'export'
    GROUP = 'group'
    LIST = 'list'
    LISTS = 'lists'
    MEMBERS = 'members'
    METRIC = 'metric'
    METRICS = 'metrics'
    PERSON = 'person'
    SUBSCRIBE = 'subscribe'
    TIMELINE = 'timeline'

    DEFAULT_COUNT = 100
    DEFAULT_PAGE = 0
    DEFAULT_SORT = 'desc'

    private

    def self.request(method, path, kwargs = {})
      check_private_api_key_exists()
      url = "#{BASE_API_URL}/#{path}"
      connection = Faraday.new(
        url: url,
        headers: {
          'Content-type' => 'application/json'
      })
      response = connection.send(method.downcase) do |req|
        req.body = kwargs[:body].to_json || nil
      end
      puts response.body
    end

    def self.public_request(method, path, kwargs = {})
      check_public_api_key_exists()
      params = build_params(kwargs)
      url = "#{BASE_API_URL}/#{path}?#{params}"
      res = Faraday.get(url).body
    end

    def self.V1_API_request(method, path, kwargs = {})
      defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
      params = defaults.merge(kwargs)
      query_params = encode_params(params)
      url_params = "api_key=#{Klaviyo.private_api_key}#{query_params}"
      full_path = "#{V1_API}/#{path}?#{url_params}"
      request(method, full_path)
    end

    def self.V2_API_request(method, path, kwargs = {})
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
