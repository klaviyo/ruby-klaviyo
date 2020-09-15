module Klaviyo
  class Metrics < Client
    @@metric = 'metric'
    @@metrics = 'metrics'
    @@timeline = 'timeline'

    # Returns a list of all metrics in Klaviyo
    # @param page [Integer] which page to return, default 0
    # @param count [Integer] number of results to return, default 100
    # @return a dictionary with a data property that contains an array of all the metrics
    def self.get_metrics(kwargs = {})
      Klaviyo::Client.v1_request('GET', @@metrics, kwargs)
    end

    # Returns a batched timeline of all events in your Klaviyo account.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @return a dictionary with a data property that contains an array of the metrics
    def self.get_metric_timeline(kwargs = {})
      path = "#{@@metrics}/#{@@timeline}"
      Client.v1_request('GET', path, kwargs)
    end

    # Returns a batched timeline for one specific type of metric.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @return a dictionary with a data property that contains information about what metric the event tracks
    def self.get_specific_metric_timeline(metric_id, kwargs = {})
      path = "#{@@metric}/#{metric_id}/#{@@timeline}"
      Client.v1_request('GET', path, kwargs)
    end
  end
end
