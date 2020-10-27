class Profiles < Klaviyo::Client
  # Retrieve all the data attributes for a Klaviyo Person ID.
  # @param person_id [String] the id of the profile
  # @return returns a person object
  def self.get_person_attributes(person_id)
    path = "#{PERSON}/#{person_id}"
    v1_request(HTTP_GET, path)
  end

  # Add or update one more more attributes for a Person
  # @param person_id [String] the id of the profile
  # @param kwargs [Key/value pairs] attributes to add/update in the profile
  # @return returns the updated person object
  def self.update_person_attributes(person_id, kwargs = {})
    path = "#{PERSON}/#{person_id}"
    v1_request(HTTP_PUT, path, kwargs)
  end

  # Listing a person's event timeline
  # @param person_id [String] the id of the profile
  # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
  # @param count [Integer] number of results to return, default 100
  # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
  # @return returns a dictionary containing a list of metric event objects
  def self.get_person_metrics_timeline(person_id, since = Time.now.to_i, count = DEFAULT_COUNT, sort = DEFAULT_SORT)
    path = "#{PERSON}/#{person_id}/#{METRICS}/#{TIMELINE}"
    params = {
      :since => since,
      :count => count,
      :sort => sort
    }
    puts params
    v1_request(HTTP_GET, path, params)
  end

  # Listing a person's event timeline for a particular metric
  # @param person_id [String] the id of the profile
  # @param metric_id [String] the id of the metric
  # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
  # @param count [Integer] number of results to return, default 100
  # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
  # @return returns a dictionary containing a list of metric event objects
  def self.get_person_metric_timeline(person_id, metric_id, since = Time.now.to_i, count = DEFAULT_COUNT, sort = 'desc')
    path = "#{PERSON}/#{person_id}/#{METRIC}/#{metric_id}/#{TIMELINE}"
    params = {
      :since => since,
      :count => count,
      :sort => sort
    }
    v1_request(HTTP_GET, path, params)
  end
end
