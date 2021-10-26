module Klaviyo
  class Metrics < Client
    EXPORT = 'export'

    # Returns a list of all metrics in Klaviyo
    # @param page [Integer] which page to return, default 0
    # @param count [Integer] number of results to return, default 100
    # @kwarg :api_key [String] private API key for this request
    # @return a dictionary with a data property that contains an array of all the metrics
    def self.get_metrics(page: DEFAULT_PAGE, count: DEFAULT_COUNT, api_key: nil)
      params = {
        :page => page,
        :count => count
      }
      v1_request(HTTP_GET, METRICS, api_key: api_key, **params)
    end

    # Returns a batched timeline of all events in your Klaviyo account.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @kwarg :api_key [String] private API key for this request
    # @return a dictionary with a data property that contains an array of the metrics
    def self.get_metrics_timeline(since: nil, count: DEFAULT_COUNT, sort: DEFAULT_SORT_DESC, api_key: nil)
      path = "#{METRICS}/#{TIMELINE}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      v1_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Returns a batched timeline for one specific type of metric.
    # @param metric_id [String] the id of the metric
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @kwarg :api_key [String] private API key for this request
    # @return a dictionary with a data property that contains information about what metric the event tracks
    def self.get_metric_timeline(metric_id, since: nil, count: DEFAULT_COUNT, sort: DEFAULT_SORT_DESC, api_key: nil)
      path = "#{METRIC}/#{metric_id}/#{TIMELINE}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      v1_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Export event data, optionally filtering and segmented on available event properties
    # @param metric_id [String] the id of the metric
    # @param start_date [String] Beginning of the timeframe to pull event data for.  Default is 1 month ago
    # @param end_date [String] End of the timeframe to pull event data for.  Default is the current day
    # @param unit [String] Granularity to bucket data points into - one of ‘day’, ‘week’, or ‘month’. Defaults to ‘day’.
    # @param measurement [String or JSON-encoded list] Type of metric to fetch
    # @param where [JSON-encoded list] Conditions to use to filter the set of events. A max of 1 condition can be given.
    # @param by [String] The name of a property to segment the event data on. Where and by parameters cannot be specified at the same time.
    # @param count [Integer] Maximum number of segments to return. The default value is 25.
    # @kwarg :api_key [String] private API key for this request
    # @return A dictionary relecting the input request parameters as well as a results property
    def self.get_metric_export(metric_id,
                               start_date: nil,
                               end_date: nil,
                               unit: nil,
                               measurement: nil,
                               where: nil,
                               by: nil,
                               count: nil,
                               api_key: nil
                               )
      path = "#{METRIC}/#{metric_id}/#{EXPORT}"
      params = {
        :start_date => start_date,
        :end_date => end_date,
        :unit => unit,
        :measurement => measurement,
        :where => where,
        :by => by,
        :count => count
      }
      v1_request(HTTP_GET, path, api_key: api_key, **params)
    end
  end
end
