require 'open-uri'
require 'base64'
require 'json'
#require pry for testing
require 'pry'

module Klaviyo
  class KlaviyoError < StandardError; end

  # Error messages
  NO_PRIVATE_API_KEY_ERROR = 'Please provide Private API key for this request'

  class Client
    def initialize(api_key = nil, private_api_key = nil, url = 'https://a.klaviyo.com/api/')
      if !api_key
        KlaviyoError.new('Please provide your Public API key')
      end

      @api_key = api_key
      @private_api_key = private_api_key
      @url = url
      @metrics_version = 'v1'

      if @private_api_key
        @private_api_key_param = "api_key=#{@private_api_key}"
      end

      @metrics_path = "#{@metrics_version}/metrics"
      @timeline_path = 'timeline'
      @metrics_timeline_path = "#{@metrics_path}/#{@timeline_path}"
      @metric_timeline_path = "#{@metrics_version}/metric"

    end

# METRICS API

# Listing metrics
    def get_metrics(kwargs = {})

      request(@metrics_path, kwargs)
    end

# Listing the complete event timeline
    def get_metrics_timeline(kwargs = {})

      request(@metrics_timeline_path, kwargs)
    end

# Listing the event timeline for a particular metric
    def get_specific_metric_timeline(metric_id, kwargs = {})

      url = "#{@metric_timeline_path}/#{metric_id}/#{@timeline_path}"

      request(url, kwargs)
    end

# END METRICS API

# START LISTS API

# get lists from lists api
    def get_lists()
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
    def request(path, params)

      if path == 'track' || path == 'identify'
        url = "#{@url}#{path}?#{params}"
        puts "request() url is #{url}"
      else

        check_private_api_key_exists()
        
        defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
        kwargs = defaults.merge(params)
        query_params = encode_params(kwargs)

        url_params = "#{@private_api_key_param}#{query_params}"
        url = "#{@url}#{path}?#{url_params}"

        puts "request() url is #{url}"

      end

      res = open(url).read

      puts "response is #{res}"

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
