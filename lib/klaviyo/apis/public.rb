module Klaviyo
  class Public < Client
    # Used for identifying customers and managing profile properties
    #
    # @kwarg :id [String] the customer or profile id
    # @kwarg :email [String] the customer or profile email
    # @kwarg :phone_number [String] the customer or profile phone number
    # @kwarg :properties [Hash] properties of the profile to add or update
    # @kwarg :token [String] public API token for this request
    # @kwargs :method [String] the HTTP method to use for the request. Accepts 'get' or 'post'.  Defaults to 'get'.
    def self.identify(kwargs = {})
      defaults = {:id => nil,
                  :email => nil,
                  :phone_number => nil,
                  :properties => {},
                  :method => HTTP_GET,
                  :token => nil
                 }
      kwargs = defaults.merge(kwargs)

      unless check_required_args(kwargs)
        return
      end

      properties = kwargs[:properties]
      properties[:email] = kwargs[:email] unless kwargs[:email].to_s.empty?
      properties[:$phone_number] = kwargs[:phone_number] unless kwargs[:phone_number].to_s.empty?
      properties[:id] = kwargs[:id] unless kwargs[:id].to_s.empty?

      token = kwargs[:token] || Klaviyo.public_api_key || nil

      params = {
        :token => token,
        :properties => properties
      }

      public_request(kwargs[:method], 'identify', **params)
    end

    # Used for tracking events and customer behaviors
    #
    # @param event [String] the event to track
    # @kwarg :id [String] the customer or profile id
    # @kwarg :email [String] the customer or profile email
    # @kwarg :phone_number [String] the customer or profile phone number
    # @kwarg :properties [Hash] properties of the event
    # @kwargs :customer_properties [Hash] properties of the customer or profile
    # @kwargs :time [Integer] timestamp of the event
    # @kwarg :token [String] public API token for this request
    # @kwargs :method [String] the HTTP method to use for the request. Accepts 'get' or 'post'.  Defaults to 'get'.
    def self.track(event, kwargs = {})
      defaults = {
        :id => nil,
        :email => nil,
        :phone_number => nil,
        :properties => {},
        :customer_properties => {},
        :time => nil,
        :method => HTTP_GET,
        :token => nil
      }

      kwargs = defaults.merge(kwargs)

      unless check_required_args(kwargs)
        return
      end

      customer_properties = kwargs[:customer_properties]
      customer_properties[:email] = kwargs[:email] unless kwargs[:email].to_s.empty?
      customer_properties[:$phone_number] = kwargs[:phone_number] unless kwargs[:phone_number].to_s.empty?
      customer_properties[:id] = kwargs[:id] unless kwargs[:id].to_s.empty?

      token = kwargs[:token] || Klaviyo.public_api_key || nil

      params = {
        :token => token,
        :event => event,
        :properties => kwargs[:properties],
        :customer_properties => customer_properties
      }
      params[:time] = kwargs[:time] if kwargs[:time]

      public_request(kwargs[:method], 'track', **params)
    end

    def self.track_once(event, kwargs = {})
      kwargs.update('__track_once__' => true)
      track(event, kwargs)
    end
  end
end
