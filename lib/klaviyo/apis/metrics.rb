require 'date'

module Klaviyo
  class Metrics < Client
    # Returns a list of all metrics in Klaviyo
    # @param page [Integer] which page to return, default 0
    # @param count [Integer] number of results to return, default 100
    # @return a dictionary with a data property that contains an array of all the metrics
    def self.get_metrics(page = DEFAULT_PAGE, count = DEFAULT_COUNT)
      params = {
        :page => page,
        :count => count
      }
      Klaviyo::Client.v1_request(HTTP_GET, metrics, params)
    end

    # Returns a batched timeline of all events in your Klaviyo account.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @return a dictionary with a data property that contains an array of the metrics
    def self.get_metrics_timeline(since = Time.now.to_i, count = default_count, sort = default_sort)
      path = "#{METRICS}/#{TIMELINE}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      Client.v1_request(HTTP_GET, path, params)
    end

    # Returns a batched timeline for one specific type of metric.
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @return a dictionary with a data property that contains information about what metric the event tracks
    def self.get_metric_timeline(metric_id, since = Time.now.to_i, count = DEFAULT_COUNT, sort = 'desc')
      path = "#{METRIC}/#{metric_id}/#{TIMELINE}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      Client.v1_request(HTTP_GET, path, params)
    end

    # Export event data, optionally filtering and segmented on available event properties
    # @param start_date [String] Beginning of the timeframe to pull event data for.  Default is 1 month ago
    # @param end_date [String] End of the timeframe to pull event data for.  Default is the current day
    # @param unit [String] Granularity to bucket data points into - one of ‘day’, ‘week’, or ‘month’. Defaults to ‘day’.
    # @param measurement [String or JSON-encoded list] Type of metric to fetch
    # @param where [JSON-encoded list] Conditions to use to filter the set of events. A max of 1 condition can be given.
    # @param by [String] The name of a property to segment the event data on. Where and by parameters cannot be specified at the same time.
    # @param count [Integer] Maximum number of segments to return. The default value is 25.
    def self.get_metric_export(metric_id,
                               start_date = Date.today.prev_month.to_s,
                               end_date = Time.now.to_s.split(' ')[0],
                               unit = 'day',
                               measurement = 'count',
                               where = nil,
                               by = nil,
                               count = 25
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
      Client.v1_request(HTTP_GET, path, params)
    end
  end
end
