module Klaviyo
  class Profiles < Client
    @@metric = 'metric'
    @@metrics = 'metrics'
    @@person = 'person'
    @@timeline = 'timeline'

    def self.get_person_attributes(person_id)
      path = "#{@@person}/#{person_id}"
      v1_request('GET', path)
    end

    def self.update_person_attributes(person_id, kwargs = {})
      path = "#{@@person}/#{person_id}"
      v1_request('PUT', path, kwargs)
    end

    def self.get_person_metrics_timeline(person_id, kwargs = {})
      path = "#{@@person}/#{person_id}/#{@@metrics}/#{@@timeline}"
      v1_request('GET', path, kwargs)
    end

    def self.get_person_metric_timeline(person_id, metric_id, kwargs = {})
      path = "#{@@person}/#{person_id}/#{@@metric}/#{metric_id}/#{@@timeline}"
      v1_request('GET', path, kwargs)
    end
  end
end
