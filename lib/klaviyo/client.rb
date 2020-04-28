require 'open-uri'
require 'base64'
require 'json'
#require pry for testing
require 'pry'

module Klaviyo
  class KlaviyoError < StandardError; end

  class Client
    def initialize(api_key, url = 'https://a.klaviyo.com/api/')
      @api_key = api_key
      @url = url
    end

# get metrics from metrics api
    def get_metrics(private_api_key)
      metrics_path = 'v1/metrics'
      param = 'api_key=' + private_api_key

      res = request(metrics_path, param)

      puts "response is #{res}"
    end

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
      puts "url is #{url}"
      open(url).read
    end
  end
end

#add binding.pry for ruby repl testing
binding.pry
