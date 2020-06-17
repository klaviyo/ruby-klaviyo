require 'open-uri'
require 'base64'
require 'json'
#require pry for testing
require 'pry'
require 'Faraday'

module Klaviyo
  class KlaviyoError < StandardError; end

  # Error messages
  NO_PRIVATE_API_KEY_ERROR = 'Please provide Private API key for this request'

  class Client
    def initialize(api_key = nil, private_api_key = nil, domain = 'https://a.klaviyo.com/api')
      if !api_key
        KlaviyoError.new('Please provide your Public API key')
      end

      @api_key = api_key
      @private_api_key = private_api_key
      @domain = domain

      if @private_api_key
        @private_api_key_param = "api_key=#{@private_api_key}"
      end

      @v1 = 'v1'
      @v2 = 'v2'
      @metric = 'metric'
      @metrics = 'metrics'
      @timeline = 'timeline'
      @lists = 'lists'

    end

# METRICS API
#    def get_metrics_fara(params = {})
#      check_private_api_key_exists()
#
#      defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
#      kwargs = defaults.merge(params)
#      query_params = encode_params(kwargs)
#
#      url_params = "#{@private_api_key_param}#{query_params}"
#      url = "#{@domain}/#{@v1}/#{@metrics}?#{url_params}"
#
#      puts "request() url is #{url}"
#
#      res = Faraday.get(url)
#
#      puts "response is #{res.body}"
#    end

# Listing metrics
    def get_metrics(kwargs = {})
      path = @metrics

      v1_request('GET', path, kwargs)
    end

# Listing the complete event timeline
    def get_metrics_timeline(kwargs = {})

      path = "#{@metrics}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

# Listing the event timeline for a particular metric
    def get_specific_metric_timeline(metric_id, kwargs = {})

      path = "#{@metric}/#{metric_id}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

# END METRICS API

# START LISTS v1 API

# get lists from lists api
    def get_lists(kwargs = {})
      path = "#{@lists}"

      v1_request(path, kwargs)
    end

# END LISTS API

    def track(event, kwargs = {})
      defaults = {:id => nil, :email => nil, :properties => {}, :customer_properties => {}, :time => nil}
      kwargs = defaults.merge(kwargs)

      if kwargs[:email].to_s.empty? and kwargs[:id].to_s.empty?
        raise KlaviyoError.new('You must identify a user by email or ID')
      end

      customer_properties = kwargs[:customer_properties]
      customer_properties[:email] = kwargs[:email] unless kwargs[:email].to_s.empty?
      customer_properties[:id] = kwargs[:id] unless kwargs[:id].to_s.empty?

      params = {
        :token => @api_key,
        :event => event,
        :properties => kwargs[:properties],
        :customer_properties => customer_properties,
        :ip => ''
      }
      params[:time] = kwargs[:time].to_time.to_i if kwargs[:time]

      params = build_params(params)
      request('track', params)
    end

    def track_once(event, opts = {})
      opts.update('__track_once__' => true)
      track(event, opts)
    end

    def identify(kwargs = {})
      defaults = {:id => nil, :email => nil, :properties => {}}
      kwargs = defaults.merge(kwargs)

      if kwargs[:email].to_s.empty? and kwargs[:id].to_s.empty?
        raise KlaviyoError.new('You must identify a user by email or ID')
      end

      properties = kwargs[:properties]
      properties[:email] = kwargs[:email] unless kwargs[:email].to_s.empty?
      properties[:id] = kwargs[:id] unless kwargs[:id].to_s.empty?

      params = build_params({
        :token => @api_key,
        :properties => properties
      })
      request('identify', params)
    end

    private

# removed CGI.escape from right after opening curly -- for testing environment
    def build_params(params)
      "data=#{Base64.encode64(JSON.generate(params)).gsub(/\n/,'')}"
    end

# prints the url, doesnt return true/false from response anymore
    def request(method = "GET", path, kwargs)

      if path == 'track' || path == 'identify'
        params = build_params(kwargs)
        url = "#{@domain}/#{path}?#{params}"
        puts "track/id url is #{url}"
      else

        check_private_api_key_exists()

        defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
        params = defaults.merge(kwargs)
        query_params = encode_params(params)

        url_params = "#{@private_api_key_param}#{query_params}"
        url = "#{@domain}/#{path}?#{url_params}"

        puts "request() url is #{url}"

      end

      puts "request() url is #{url}"

      res = Faraday.get(url)

      puts "response is #{res.body}"

    end

    def v1_request(method, path, kwargs)
      path = "#{@v1}/#{path}"
      request(method, path, kwargs)
    end

# check if private api key exists, if not, throw error
    def check_private_api_key_exists()
      if !@private_api_key
        raise KlaviyoError.new(NO_PRIVATE_API_KEY_ERROR)
      end
    end

# return URL encoded params from kwargs
# if there are no params, return nothing
    def encode_params(kwargs)
      # remove k/v pairs that are nil (v is tru)
      kwargs.select!{|k, v| v}
      params = URI.encode_www_form(kwargs)

      if !params.empty?
        return "&#{params}"
      end
    end
  end
end

#add binding.pry for ruby repl testing
binding.pry
