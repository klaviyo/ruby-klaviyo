module Klaviyo
  class Profiles < Client
    PERSON = 'person'
    PEOPLE = 'people'
    SEARCH = 'search'

    # Retrieves the id of the profile given email
    # @param email [String] the email of the profile
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing id of the profile
    def self.get_profile_id_by_email(email, api_key: nil)
      path = "#{PEOPLE}/#{SEARCH}"
      params = {
        :email => email
      }
      v2_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Retrieve all the data attributes for a Klaviyo Person ID.
    # @param person_id [String] the id of the profile
    # @kwarg :api_key [String] private API key for this request
    # @return returns a person object
    def self.get_person_attributes(person_id, api_key: nil)
      path = "#{PERSON}/#{person_id}"
      v1_request(HTTP_GET, path, api_key: api_key)
    end

    # Add or update one more more attributes for a Person
    # @param person_id [String] the id of the profile
    # @param kwargs [Key/value pairs] attributes to add/update in the profile
    # @return returns the updated person object
    def self.update_person_attributes(person_id, kwargs = {})
      path = "#{PERSON}/#{person_id}"
      v1_request(HTTP_PUT, path, **kwargs)
    end

    # Listing a person's event timeline
    # @param person_id [String] the id of the profile
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @kwarg :api_key [String] private API key for this request
    # @return returns a dictionary containing a list of metric event objects
    def self.get_person_metrics_timeline(person_id, since: nil, count: DEFAULT_COUNT, sort: DEFAULT_SORT_DESC, api_key: nil)
      path = "#{PERSON}/#{person_id}/#{METRICS}/#{TIMELINE}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      v1_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Listing a person's event timeline for a particular metric
    # @param person_id [String] the id of the profile
    # @param metric_id [String] the id of the metric
    # @param since [Integer or String] either a Unix timestamp or the UUID from a previous request.  Default is the current time.
    # @param count [Integer] number of results to return, default 100
    # @param sort [String] 'asc' or 'desc', sort order to apply to the timeline.  Default is 'desc'.
    # @kwarg :api_key [String] private API key for this request
    # @return returns a dictionary containing a list of metric event objects
    def self.get_person_metric_timeline(person_id, metric_id, since: nil, count: DEFAULT_COUNT, sort: DEFAULT_SORT_DESC, api_key: nil)
      path = "#{PERSON}/#{person_id}/#{METRIC}/#{metric_id}/#{TIMELINE}"
      params = {
        :since => since,
        :count => count,
        :sort => sort
      }
      v1_request(HTTP_GET, path, api_key: api_key, **params)
    end
  end
end
