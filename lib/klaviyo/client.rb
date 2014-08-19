require 'open-uri'
require 'base64'
require 'json'

module Klaviyo
  class KlaviyoError < StandardError; end
  
  class Client
    def initialize(api_key, url = 'http://a.klaviyo.com/')
      @api_key = api_key
      @url = url
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
      request('crm/api/track', params)
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
      request('crm/api/identify', params)
    end

    private
    
    def build_params(params)
      'data=' + Base64.encode64(JSON.generate(params)).gsub(/\n/,'')
    end
    
    def request(path, params)
        url = @url + path + '?' + params
        open(url).read == '1' ? true : false
    end
  end
end
