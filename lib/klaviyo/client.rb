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

# START PROFILES API

# Retrieve a person's attributes
    def get_person_attributes(person_id)

      path = "#{@person}/#{person_id}"

      v1_request('GET', path)
    end

# Adding or Updating a Person's Attributes
    def update_person_attributes(person_id, kwargs)

      path = "#{@person}/#{person_id}"

      v1_request('PUT', path, kwargs)
    end

# Listing a person's complete event timeline
    def get_person_metrics_timeline(person_id, kwargs = {})

      path = "#{@person}/#{person_id}/#{@metrics}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

# Listing a person's event timeline for a particular metric
    def get_person_metric_timeline(person_id, metric_id, kwargs = {})

      path = "#{@person}/#{person_id}/#{@metric}/#{metric_id}/#{@timeline}"

      v1_request('GET', path, kwargs)
    end

# END PROFILES API

# START LISTS v2 API

# Create a new list
    def create_list(list_name)
      path = "#{@lists}"

      body = {
        "list_name": list_name
      }

      v2_request('POST', path, body)
    end

# get lists from lists api
    def get_lists()
      path = "#{@lists}"

      v2_request('GET', path)
    end

# Get List Details
    def get_list_details(list_id)
      path = "#{@list}/#{list_id}"

      v2_request('GET', path)
    end

# Update List Details
    def update_list_details(list_id, list_name)
      path = "#{@list}/#{list_id}"

      body = {
        "list_name": list_name
      }

      v2_request('PUT', path, body)
    end

# Delete a list
    def delete_list(list_id)
      path = "#{@list}/#{list_id}"

      v2_request('DELETE', path)
    end

# LIST SUBSCRIPTIONS

# Check if profiles are on a list and not suppressed. Not Working
    def check_list_subscriptions(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@subscribe}"

      v2_request('GET', path, kwargs)
    end

# Unsubscribe and remove profiles from a list.
    def unsubscribe_from_list(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@subscribe}"

      v2_request('DELETE', path, kwargs)
    end

# List Memberships

# Add to list
    def add_to_list(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@members}"

      v2_request('POST', path, kwargs)
    end

# Check list membership
    def check_list_memberships(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@members}"

      v2_request('GET', path, kwargs)
    end

# Remove from list
    def remove_from_list(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@members}"

      v2_request('DELETE', path, kwargs = {})
    end

# List exclusions
    def get_list_exclusions(list_id, kwargs = {})
      path = "#{@list}/#{list_id}/#{@exclusions}/#{@all}"

      v2_request('GET', path, kwargs = {})
    end

# Group Memberships
    def get_group_members(list_id)
      path = "#{@group}/#{list_id}/#{@members}/#{@all}"

      v2_request('GET', path)
    end

# END LISTS API

# In track/identify we are building params in the reuqest, should do that in
# request method?
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

#      params = build_params(params)
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

# removed CGI.escape from right after opening curly -- for testing environment
    def build_params(params)
      "data=#{Base64.encode64(JSON.generate(params)).gsub(/\n/,'')}"
    end

# prints the url, doesnt return true/false from response anymore
    def request(method = 'GET', path, kwargs)

      if path == 'track' || path == 'identify'
        params = build_params(kwargs)
        url = "#{@domain}/#{path}?#{params}"

        puts "request() url is #{url}"

        res = Faraday.get(url)

        puts "response is #{res.body}"

      elsif kwargs[:body]

        check_private_api_key_exists()

        url = "#{@domain}/#{path}"

        puts "request() url is #{url}"

        if method == 'GET'

          res = Faraday.get(url, kwargs[:body])

          puts "response is #{res.body}"

        elsif method == 'POST'

          res = Faraday.post(url, kwargs[:body])

          puts "response is #{res.body}"

        elsif method == 'PUT'

          res = Faraday.put(url, kwargs[:body])

          puts "response is #{res.body}"

        elsif method == 'DELETE'

          res = Faraday.delete(url, kwargs[:body])

          puts "response is #{res.body}"
        end

      elsif method == 'GET'

        check_private_api_key_exists()

        defaults = {:page => nil, :count => nil, :since => nil, :sort => nil}
        params = defaults.merge(kwargs)
        query_params = encode_params(params)

        url_params = "#{@private_api_key_param}#{query_params}"
        url = "#{@domain}/#{path}?#{url_params}"

        puts "request() url is #{url}"

        res = Faraday.get(url)

        puts "response is #{res.body}"

      elsif method == 'PUT'

        check_private_api_key_exists()

        query_params = encode_params(kwargs)

        url_params = "#{@private_api_key_param}#{query_params}"
        url = "#{@domain}/#{path}?#{url_params}"

        puts "request() url is #{url}"

        res = Faraday.put(url)

        puts "response is #{res.body}"
      end
    end

    def v1_request(method, path, kwargs = {})
      path = "#{@v1}/#{path}"
      request(method, path, kwargs)
    end

    def v2_request(method, path, kwargs = {})
      path = "#{@v2}/#{path}"

      key = {
        "api_key": "#{@private_api_key}"
      }

      body = key.merge(kwargs)

      kwargs[:body] = body

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
