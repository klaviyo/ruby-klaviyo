require 'open-uri'
require 'base64'
require 'json'
#require pry for testing
require 'pry'

module Klaviyo
  class KlaviyoError < StandardError; end

  class Client
    def initialize(api_key = nil, private_api_key = nil, url = 'https://a.klaviyo.com/api/')
      if !api_key
        raise 'Please provide your Public API key'
      end

      @api_key = api_key
      @private_api_key = private_api_key
      @url = url

      if @private_api_key
        @private_api_key_param = "api_key=#{@private_api_key}"
      end
# API versions
      @metrics_version = 'v1/'

# API endpoints
      @metrics_path = "#{@metrics_version}metrics"
      @timeline_path = 'timeline'
      @metrics_timeline_path = "#{@metrics_path}/#{@timeline_path}"
      @metric_timeline_path = 'v1/metric'

# Error messages
      @NO_PRIVATE_API_KEY_ERROR = 'Please provide Private API key for this request'

    end

# METRICS API

# Listing metrics
    def get_metrics(kwargs = {})
      private_api_key_exists()

      api_key_param = @private_api_key_param

      defaults = {:page => nil, :count => nil}

      kwargs = defaults.merge(kwargs)

      query_params = encode_params(kwargs)

      url_params = "#{api_key_param}#{query_params}"

      res = request(@metrics_path, url_params)

      puts "response is #{res}"
    end

# Listing the complete event timeline
    def get_metrics_timeline(kwargs = {})
      private_api_key_exists()

      api_key_param = @private_api_key_param

      defaults = {:since => nil, :count => nil, :sort => nil}

      kwargs = defaults.merge(kwargs)

      query_params = encode_params(kwargs)

      url_params = "#{api_key_param}#{query_params}"

      res = request(@metrics_path, url_params)

      puts "response is #{res}"
    end

# Listing the event timeline for a particular metric
  def get_specific_metric_timeline(metric_id, kwargs = {})
    private_api_key_exists()
    defaults = {:since => nil, :count => nil, :sort => nil}

    url_params = @private_api_key_param

    if kwargs[:since]
      since_param = "#{@since_param}#{kwargs[:since].to_s}"
      url_params = "#{url_params}&#{since_param}"
    end

    if kwargs[:count]
      count_param = "#{@count_param}#{kwargs[:count].to_s}"
      url_params = "#{url_params}&#{count_param}"
    end

# DOES THIS WORK??????????????????????????????????????
    if kwargs[:sort]
      sort_param = "#{@sort_param}#{kwargs[:sort]}"
      url_params = "#{url_params}&#{sort_param}"
    end

    url = "#{@metric_timeline_path}/#{metric_id}/#{@timeline_path}"

    res = request(url, url_params)

    puts "response is #{res}"
  end

# END METRICS API

# START LISTS API

# get lists from lists api
    def get_lists(private_api_key)
      lists_path = 'v2/lists'
      param = 'api_key=' + private_api_key

      res = request(lists_path, param)

      puts "response is #{res}"
    end

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
      url = "#{@url}#{path}?#{params}"
      puts "request() url is #{url}"
      open(url).read
    end

# check if private api key exists, if not, throw error
    def private_api_key_exists()
      if !@private_api_key
        raise @NO_PRIVATE_API_KEY_ERROR
      end
    end

# URL encode params from kwargs
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
