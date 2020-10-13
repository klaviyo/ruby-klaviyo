module Klaviyo
  class Profiles < Client
    def self.get_person_attributes(person_id)
      path = "#{PERSON}/#{person_id}"
      v1_request('GET', path)
    end

    def self.update_person_attributes(person_id, kwargs = {})
      path = "#{PERSON}/#{person_id}"
      v1_request(HTTP_PUT, path, kwargs)
    end

    def self.get_person_metrics_timeline(person_id, kwargs = {})
      path = "#{PERSON}/#{person_id}/#{METRICS}/#{timeline}"
      v1_request(HTTP_GET, path, kwargs)
    end

    def self.get_person_metric_timeline(person_id, metric_id, kwargs = {})
      path = "#{PERSON}/#{person_id}/#{METRIC}/#{metric_id}/#{TIMELINE}"
      v1_request(HTTP_GET, path, kwargs)
    end
  end
end
