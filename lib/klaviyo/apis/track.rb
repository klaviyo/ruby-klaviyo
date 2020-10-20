class Track < Client
  # Used for tracking events and customer behaviors
  #
  # @param event [String] the event to track
  # @kwarg :id [String] the customer or profile id
  # @kwarg :email [String] the customer or profile email
  # @kwarg :properties [Hash] properties of the event
  # @kwargs :customer_properties [Hash] properties of the customer or profile
  # @kwargs :time [Integer] timestamp of the event
  def self.track(event, kwargs = {})
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
      :customer_properties => customer_properties
    }
    params[:time] = kwargs[:time].to_time.to_i if kwargs[:time]

    request('GET', 'track', params)
  end

  def self.track_once(event, opts = {})
    opts.update('__track_once__' => true)
    track(event, opts)
  end
end
