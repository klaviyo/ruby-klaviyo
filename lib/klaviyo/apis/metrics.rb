module Klaviyo
  class Metrics < Client
    @@metric = 'metric'
    @@metrics = 'metrics'
    @@timeline = 'timeline'
    @@export = 'export'

    @@default_page = 0
    @@default_count = 100
    @@default_sort = 'desc'

    # Returns a list of all metrics in Klaviyo
    # @param page [Integer] which page to return, default 0
    # @param count [Integer] number of results to return, default 100
    # @return a dictionary with a data property that contains an array of all the metrics
    def self.get_metrics(page = @@default_page, count = @@default_count)
      params = {
        :page => page,
        :count => count
      }
      Klaviyo::Client.v1_request('GET', @@metrics, params)
    end

    # Returns a batched timeline of all events in your Klaviyo account.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @return a dictionary with a data property that contains an array of the metrics
    def self.get_metrics_timeline(since = Time.now.to_i, count = @@default_count, sort = @@default_sort)
      path = "#{@@metrics}/#{@@timeline}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      Client.v1_request('GET', path, params)
    end

    # Returns a batched timeline for one specific type of metric.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @return a dictionary with a data property that contains information about what metric the event tracks
    def self.get_metric_timeline(metric_id, since = Time.now.to_i, count = 100, sort = 'desc')
      path = "#{@@metric}/#{metric_id}/#{@@timeline}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      Client.v1_request('GET', path, params)
    end
  end
end
