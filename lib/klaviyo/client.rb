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
    METRIC = 'metric'
    METRICS = 'metrics'
    TIMELINE = 'timeline'

    DEFAULT_COUNT = 100
    DEFAULT_PAGE = 0
    DEFAULT_SORT_DESC = 'desc'

    CONTENT_JSON = 'application/json'
    CONTENT_URL_FORM = 'application/x-www-form-urlencoded'

    include Klaviyo::Campaigns
    include Klaviyo::DataPrivacy
    include Klaviyo::EmailTemplates
    include Klaviyo::Lists
    include Klaviyo::Metrics
    include Klaviyo::Profiles
    include Klaviyo::Public

    def initialize(public_api_key, private_api_key)
      @public_api_key = public_api_key
      @private_api_key = private_api_key
    end

    def request(method, path, content_type, **kwargs)
      url = "#{BASE_API_URL}/#{path}"
      connection = Faraday.new(
        url: url,
        headers: {
          'Content-Type' => content_type
      })
      if content_type == CONTENT_JSON
        kwargs[:body] = kwargs[:body].to_json
      end
      response = connection.send(method) do |req|
        req.body = kwargs[:body] || nil
      end
    end

    def public_request(method, path, **kwargs)
      params = build_params(kwargs)
      url = "#{BASE_API_URL}/#{path}?#{params}"
      res = Faraday.get(url).body
    end

    def v1_request(method, path, content_type: CONTENT_JSON, **kwargs)
      if content_type == CONTENT_URL_FORM
        data = {
          :body => {
            :api_key => @private_api_key
          }
        }
        data[:body] = data[:body].merge(kwargs[:params])
        full_url = "#{V1_API}/#{path}"
        request(method, full_url, content_type, **data)
      else
        defaults = {:page => nil,
                    :count => nil,
                    :since => nil,
                    :sort => nil}
        params = defaults.merge(kwargs)
        query_params = encode_params(params)
        full_url = "#{V1_API}/#{path}?api_key=#{@private_api_key}#{query_params}"
        request(method, full_url, content_type)
      end
    end

    def v2_request(method, path, **kwargs)
      path = "#{V2_API}/#{path}"
      key = {
        "api_key": "#{@private_api_key}"
      }
      data = {}
      data[:body] = key.merge(kwargs)
      request(method, path, CONTENT_JSON, **data)
    end

    def build_params(params)
      "data=#{CGI.escape(Base64.encode64(JSON.generate(params)).gsub(/\n/, ''))}"
    end

    def check_required_args(kwargs)
      if kwargs[:email].to_s.empty? and kwargs[:phone_number].to_s.empty? and kwargs[:id].to_s.empty?
        raise Klaviyo::KlaviyoError.new(REQUIRED_ARG_ERROR)
      else
        return true
      end
    end

    def encode_params(kwargs)
      kwargs.select!{|k, v| v}
      params = URI.encode_www_form(kwargs)

      if !params.empty?
        return "&#{params}"
      end
    end
  end
end
