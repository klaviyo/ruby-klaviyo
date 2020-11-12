require 'open-uri'
require 'base64'
require 'json'
require 'rest-client'
require_relative '../klaviyo/lists'

module Klaviyo
  class KlaviyoError < StandardError; end

  class Client

    # need to compare with previous one
    #include Klaviyo::Lists

    def initialize(api_key, url = 'https://a.klaviyo.com/')
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
      request('api/track', params)
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
      request('api/identify', params)
    end

    ## added functionality
    def lists
      RestClient.get("#{@url}api/v2/lists", params: {api_key: @api_key}) do |response, request, result, &block|
        if response.code == 200
          JSON.parse(response)
        else
          raise KlaviyoError.new(response)
        end
      end
    end

    def add_to_list(email, list_id, properties, confirm_optin)
      payload = {
          api_key: @api_key,
          profiles: [
              { email: email }.merge(properties)
          ]
      }

      sub_or_members = confirm_optin ? 'subscribe' : 'members'
      RestClient.post("#{@url}api/v2/list/#{list_id}/#{sub_or_members}", payload.to_json, {content_type: :json, accept: :json}) do |response, request, result, &block|
        if response.code == 200
          JSON.parse(response)
        else
          raise KlaviyoError.new(JSON.parse(response))
        end
      end
    end

    def get_profile(id)
      RestClient.get("#{@url}api/v1/person/#{id}", params: {api_key: @api_key}) do |response, request, result, &block|
        if response.code == 200
          JSON.parse(response)
        else
          raise KlaviyoError.new(response)
        end
      end
    end

    def update_profile(id, properties)
      payload = properties.merge(api_key: @api_key)
      RestClient.put("#{@url}api/v1/person/#{id}", payload) do |response, request, result, &block|
        if response.code == 200
          JSON.parse(response)
        else
          raise KlaviyoError.new(JSON.parse(response))
        end
      end
    end

    def remove_from_list(email, list_id)
      payload = {
          api_key: @api_key,
          email: email
      }

      RestClient.post("#{@url}/api/v1/list/#{list_id}/members/exclude", payload) do |response, request, result, &block|
        if response.code == 200
          JSON.parse(response)
        else
          raise KlaviyoError.new(JSON.parse(response))
        end
      end
    end

    # need to update
    # def email_update()
    #  if event_description == 'Updated Email'
    #    identify_lead('Became Lead (email)')
    #    response = HTTParty.get("https://a.klaviyo.com/api/v2/people/search?api_key=#{@private_api_key}&email=#{event_details[:email]}")
    #    lead_id = JSON.parse(response.body)["id"]
    #    if lead_id.present?
    #      HTTParty.put("https://a.klaviyo.com/api/v1/person/#{lead_id}?api_key=#{@private_api_key}&email=#{event_details[:new_email]}")
    #    end
    #  end
    #end

    private

    def build_params(params)
      "data=#{CGI.escape Base64.encode64(JSON.generate(params)).gsub(/\n/,'')}"
    end

    def request(path, params)
      url = "#{@url}#{path}?#{params}"
      open(url).read == '1'
    end
  end
end
