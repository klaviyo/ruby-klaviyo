require 'open-uri'
require 'base64'
require 'json'
require 'Faraday'

module Klaviyo
  class KlaviyoError < StandardError; end

  NO_PRIVATE_API_KEY_ERROR = 'Please provide Private API key for this request'

  class Client
    def initialize(api_key = nil, private_api_key = nil)
      if !api_key
        KlaviyoError.new('Please provide your Public API key')
      end

      @api_key = api_key
      @private_api_key = private_api_key
      @domain = 'https://a.klaviyo.com/api'

      if @private_api_key
        @private_api_key_param = "api_key=#{@private_api_key}"
      end

      @v1 = 'v1'
      @v2 = 'v2'
      @metric = 'metric'
      @metrics = 'metrics'
      @timeline = 'timeline'
      @list = 'list'
      @lists = 'lists'
      @person = 'person'
      @subscribe = 'subscribe'
      @members = 'members'
      @exclusions = 'exclusions'
      @all = 'all'
      @group = 'group'

    end

# METRICS API

    def get_metrics(kwargs = {})
      path = @metrics

      v1_request('GET', path, kwargs)
    end

    def get_metrics_timeline(kwargs = {})
      path = "#{@metrics}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

    def get_specific_metric_timeline(metric_id, kwargs = {})
      path = "#{@metric}/#{metric_id}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

# PROFILES API

    def get_person_attributes(person_id)
      path = "#{@person}/#{person_id}"

      v1_request('GET', path)
    end

    def update_person_attributes(person_id, kwargs = {})
      path = "#{@person}/#{person_id}"

      v1_request('PUT', path, kwargs)
    end

    def get_person_metrics_timeline(person_id, kwargs = {})
      path = "#{@person}/#{person_id}/#{@metrics}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

    def get_person_metric_timeline(person_id, metric_id, kwargs = {})
      path = "#{@person}/#{person_id}/#{@metric}/#{metric_id}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

# LISTS API

    def create_list(list_name)
      path = "#{@lists}"

      body = {
        "list_name": list_name
      }

      v2_request('POST', path, body)
    end

    def get_lists()
      path = "#{@lists}"

      v2_request('GET', path)
    end

    def get_list_details(list_id)
      path = "#{@list}/#{list_id}"

      v2_request('GET', path)
    end

    def update_list_details(list_id, list_name)
      path = "#{@list}/#{list_id}"

      body = {
        "list_name": list_name
      }

      v2_request('PUT', path, body)
    end

    def delete_list(list_id)
      path = "#{@list}/#{list_id}"

      v2_request('DELETE', path)
    end

# LIST SUBSCRIPTIONS

    def check_list_subscriptions(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@subscribe}"

      v2_request('GET', path, kwargs)
    end

    def unsubscribe_from_list(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@subscribe}"

      v2_request('DELETE', path, kwargs)
    end

# LIST MEMBERSHIPS

    def add_to_list(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@members}"

      v2_request('POST', path, kwargs)
    end

    def check_list_memberships(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@members}"

      v2_request('GET', path, kwargs)
    end

    def remove_from_list(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@members}"

      v2_request('DELETE', path, kwargs)
    end

    def get_list_exclusions(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@exclusions}/#{@all}"

      v2_request('GET', path, kwargs)
    end

    def get_group_members(list_id)
      path = "#{@group}/#{list_id}/#{@members}/#{@all}"

      v2_request('GET', path)
    end

# TRACK/IDENTIFY

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

      request('GET', 'track', params)
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

      params = {
        :token => @api_key,
        :properties => properties
      }

      request('GET', 'identify', params)
    end

    private

    def request(method, path, kwargs = {})
      if path == 'track' || path == 'identify'
        params = build_params(kwargs)
        url = "#{@domain}/#{path}?#{params}"

        res = Faraday.get(url)

      elsif kwargs[:body]

        check_private_api_key_exists()

        url = "#{@domain}/#{path}"

        if method == 'GET'

          data = kwargs[:body].to_json

          res = Faraday.get(url) do |req|
            req.body = data
            req.headers['Content-Type'] = 'application/json'
          end

        elsif method == 'POST'

          data = kwargs[:body].to_json

          res = Faraday.post(url) do |req|
            req.body = data
            req.headers['Content-Type'] = 'application/json'
          end

        elsif method == 'PUT'

          res = Faraday.put(url) do |req|
            req.body = data
            req.headers['Content-Type'] = 'application/json'
          end

        elsif method == 'DELETE'

          res = Faraday.delete(url) do |req|
            req.body = data
            req.headers['Content-Type'] = 'application/json'
          end

        end

      elsif method == 'GET'

        url = "#{@domain}/#{path}"

        res = Faraday.get(url)

      elsif method == 'PUT'

        url = "#{@domain}/#{path}"

        res = Faraday.put(url)

      end
    end

    def v1_request(method, path, kwargs = {})

      check_private_api_key_exists()

      defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
      params = defaults.merge(kwargs)
      query_params = encode_params(params)

      url_params = "#{@private_api_key_param}#{query_params}"
      full_path = "#{@v1}/#{path}?#{url_params}"

      request(method, full_path)
    end

    def v2_request(method, path, kwargs = {})
      path = "#{@v2}/#{path}"

      key = {
        "api_key": "#{@private_api_key}"
      }

      data = {}
      data[:body] = key.merge(kwargs)

      request(method, path, data)
    end

    def build_params(params)
      "data=#{Base64.encode64(JSON.generate(params)).gsub(/\n/,'')}"
    end

    def check_private_api_key_exists()
      if !@private_api_key
        raise KlaviyoError.new(NO_PRIVATE_API_KEY_ERROR)
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
