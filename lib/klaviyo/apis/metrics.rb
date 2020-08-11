module Klaviyo
  class Metrics < Client
    @@metric = 'metric'
    @@metrics = 'metrics'
    @@timeline = 'timeline'

    def self.get_metrics(kwargs = {})
      Klaviyo::Client.v1_request('GET', @@metrics, kwargs)
    end

    def self.get_metrics_timeline(kwargs = {})
      path = "#{@@metrics}/#{@@timeline}"
      Client.v1_request('GET', path, kwargs)
    end

    def self.get_specific_metric_timeline(metric_id, kwargs = {})
      path = "#{@@metric}/#{metric_id}/#{@@timeline}"
      Client.v1_request('GET', path, kwargs)
    end
  end
end
