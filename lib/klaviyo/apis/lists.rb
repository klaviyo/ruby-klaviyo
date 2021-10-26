module Klaviyo
  class Lists < Client
    EXCLUSIONS = 'exclusions'
    GROUP = 'group'
    LIST = 'list'
    LISTS = 'lists'
    MEMBERS = 'members'
    SUBSCRIBE = 'subscribe'

    # Creates a new list
    # @param list_name [String] the list name
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP OK on success
    def self.create_list(list_name, api_key: nil)
      body = {
        :list_name => list_name
      }
      v2_request(HTTP_POST, LISTS, api_key: api_key, **body)
    end

    # Retrieves all the lists in the Klaviyo account
    # @kwarg :api_key [String] private API key for this request
    # @return [List] a list of JSON objects of the name and id for each list
    def self.get_lists(api_key: nil)
      v2_request(HTTP_GET, LISTS, api_key: api_key)
    end

    # Retrieves the details of the list
    # @param list_id [String] the id of the list
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the list
    def self.get_list_details(list_id, api_key: nil)
      path = "#{LIST}/#{list_id}"
      v2_request(HTTP_GET, path, api_key: api_key)
    end

    # Updates the properties of a list
    # @param list_id [String] the id of the list
    # @param list_name [String] the new name of the list
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP OK on success
    def self.update_list_details(list_id, list_name, api_key: nil)
      path = "#{LIST}/#{list_id}"
      body = {
        :list_name => list_name
      }
      v2_request(HTTP_PUT, path, api_key: api_key, **body)
    end

    # Deletes a list
    # @param list_id [String] the id of the list
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP OK on success
    def self.delete_list(list_id, api_key: nil)
      path = "#{LIST}/#{list_id}"
      v2_request(HTTP_DELETE, path, api_key: api_key)
    end

    # Check if profiles are in a list and not supressed
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @param :phone_numbers [List] the phone numbers of the profiles to check
    # @param :push_tokens [List] push tokens of the profiles to check
    # @kwarg :api_key [String] private API key for this request
    # @return A list of JSON objects of the profiles. Profiles that are
    #   supressed or not found are not included.
    def self.check_list_subscriptions(list_id, api_key: nil, emails: [], phone_numbers: [], push_tokens: [])
      path = "#{LIST}/#{list_id}/#{SUBSCRIBE}"
      params = {
        :emails => emails,
        :phone_numbers => phone_numbers,
        :push_tokens => push_tokens
      }
      v2_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Subscribe profiles to a list.
    # @param list_id [String] the id of the list
    # @param profiles [List] a list of JSON objects.  Each object requires either
    #   an email or phone number key.
    # @kwarg :api_key [String] private API key for this request
    # @return will retun HTTP OK on success. If the list is single opt-in then a
    #   list of records containing the email address, phone number, push token,
    #   and the corresponding profile ID will also be included.
    def self.add_subscribers_to_list(list_id, api_key: nil, profiles: [])
      path = "#{LIST}/#{list_id}/#{SUBSCRIBE}"
      params = {
        :profiles => profiles
      }
      v2_request(HTTP_POST, path, api_key: api_key, **params)
    end

    # Unsubscribe and remove profiles from a list
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP OK on success
    def self.unsubscribe_from_list(list_id, api_key: nil, emails: [])
      path = "#{LIST}/#{list_id}/#{SUBSCRIBE}"
      params = {
        :emails => emails
      }
      v2_request(HTTP_DELETE, path, api_key: api_key, **params)
    end

    # Add profiles to a list
    # @param list_id [String] the id of the list
    # @param :profiles [List] A list of JSON objects.  Each object is a profile
    #   that will be added to the list
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP OK on success and a list of records of the
    #   corresponding profile id
    def self.add_to_list(list_id, api_key: nil, profiles: [])
      path = "#{LIST}/#{list_id}/#{MEMBERS}"
      params = {
        :profiles => profiles
      }
      v2_request(HTTP_POST, path, api_key: api_key, **params)
    end

    # Check if profiles are on a list
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @param :phone_numbers [List] the phone numbers of the profiles to check
    # @param :push_tokens [List] push tokens of the profiles to check
    # @kwarg :api_key [String] private API key for this request
    # @return A list of JSON objects of the profiles. Profiles that are
    #   supressed or not found are not included.
    def self.check_list_memberships(list_id, api_key: nil, emails: [], phone_numbers: [], push_tokens: [])
      path = "#{LIST}/#{list_id}/#{MEMBERS}"
      params = {
        :emails => emails,
        :phone_numbers => phone_numbers,
        :push_tokens => push_tokens
      }
      v2_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Remove profiles from a list
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @param :phone_numbers [List] the phone numbers of the profiles to check
    # @param :push_tokens [List] push tokens of the profiles to check
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP OK on success
    def self.remove_from_list(list_id, api_key: nil, emails: [], phone_numbers: [], push_tokens: [])
      path = "#{LIST}/#{list_id}/#{MEMBERS}"
      params = {
        :emails => emails,
        :phone_numbers => phone_numbers,
        :push_tokens => push_tokens
      }
      v2_request(HTTP_DELETE, path, api_key: api_key, **params)
    end

    # Get all emails, phone numbers, along with reasons for list exclusion
    # @param list_id [String] the id of the list
    # @param marker [Integer] a marker from a previous call to get the next batch
    # @kwarg :api_key [String] private API key for this request
    # @return [List] A list of JSON object for each profile with the reason for exclusion
    def self.get_list_exclusions(list_id, api_key: nil, marker: nil)
      path = "#{LIST}/#{list_id}/#{EXCLUSIONS}/#{ALL}"
      params = {
        :marker => marker
      }
      v2_request(HTTP_GET, path, api_key: api_key, **params)
    end

    # Get all of the emails, phone numbers, and push tokens for profiles in a given list or segment
    # @param list_id [String] the id of the list
    # @param marker [Integer] a marker from a previous call to get the next batch
    # @kwarg :api_key [String] private API key for this request
    # @return [List] A list of JSON objects for each profile with the id, email, phone number, and push token
    def self.get_group_members(list_id, api_key: nil)
      path = "#{GROUP}/#{list_id}/#{MEMBERS}/#{ALL}"
      v2_request(HTTP_GET, path, api_key: api_key)
    end
  end
end
