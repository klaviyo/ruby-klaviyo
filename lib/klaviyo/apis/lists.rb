
module Klaviyo
  class Lists < Client
    @@all = 'all'
    @@exclusions = 'exclusions'
    @@group = 'group'
    @@list = 'list'
    @@lists = 'lists'
    @@members = 'members'
    @@subscribe = 'subscribe'

    # Creates a new list
    # @param list_name [String] the list name
    # @return will return with HTTP OK on success
    def self.create_list(list_name)
      path = "#{@@lists}"
      body = {
        :list_name => list_name
      }
      v2_request('POST', path, body)
    end

    # Retrieves all the lists in the Klaviyo account
    # @return [List] a list of JSON objects of the name and id for each list
    def self.get_lists()
      path = "#{@@lists}"
      v2_request('GET', path)
    end

    # Retrieves the details of the list
    # @param list_id [String] the id of the list
    # @return [JSON] a JSON object containing information about the list
    def self.get_list_details(list_id)
      path = "#{@@list}/#{list_id}"
      v2_request('GET', path)
    end

    # Updates the properties of a list
    # @param list_id [String] the id of the list
    # @param list_name [String] the new name of the list
    # @return will return with HTTP OK on success
    def self.update_list_details(list_id, list_name)
      path = "#{@@list}/#{list_id}"
      body = {
        :list_name => list_name
      }
      v2_request('PUT', path, body)
    end

    # Deletes a list
    # @param list_id [String] the id of the list
    # @return will return with HTTP OK on success
    def self.delete_list(list_id)
      path = "#{@@list}/#{list_id}"
      v2_request('DELETE', path)
    end

    # Check if profiles are in a list and not supressed
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @param :phone_numbers [List] the phone numbers of the profiles to check
    # @param :push_tokens [List] push tokens of the profiles to check
    # @return A list of JSON objects of the profiles. Profiles that are
    #   supressed or not found are not included.
    def self.check_list_subscriptions(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@subscribe}"
      v2_request('GET', path, kwargs)
    end

    # Unsubscribe and remove profiles from a list
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @return will return with HTTP OK on success
    def self.unsubscribe_from_list(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@subscribe}"
      v2_request('DELETE', path, kwargs)
    end

    # Add profiles to a list
    # @param list_id [String] the id of the list
    # @param :profiles [List] A list of JSON objects.  Each object is a profile
    #   that will be added to the list
    # @return will return with HTTP OK on success and a list of records of the
    #   corresponding profile id
    def self.add_to_list(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@members}"
      v2_request('POST', path, kwargs)
    end

    # Check if profiles are on a list
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @param :phone_numbers [List] the phone numbers of the profiles to check
    # @param :push_tokens [List] push tokens of the profiles to check
    # @return A list of JSON objects of the profiles. Profiles that are
    #   supressed or not found are not included.
    def self.check_list_memberships(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@members}"
      v2_request('GET', path, kwargs)
    end

    # Remove profiles from a list
    # @param list_id [String] the id of the list
    # @param :emails [List] the emails of the profiles to check
    # @param :phone_numbers [List] the phone numbers of the profiles to check
    # @param :push_tokens [List] push tokens of the profiles to check
    # @return will return with HTTP OK on success
    def self.remove_from_list(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@members}"
      v2_request('DELETE', path, kwargs)
    end

    # Get all emails, phone numbers, along with reasons for list exclusion
    # @param list_id [String] the id of the list
    # @param marker [Integer] a marker from a previous call to get the next batch
    # @return [List] A list of JSON object for each profile with the reason for exclusion
    def self.get_list_exclusions(list_id, kwargs = {})
      path = "#{@@list}/#{list_id}/#{@@exclusions}/#{@@all}"
      v2_request('GET', path, kwargs)
    end

    # Get all of the emails, phone numbers, and push tokens for profiles in a given list or segment
    # @param list_id [String] the id of the list
    # @param marker [Integer] a marker from a previous call to get the next batch
    # @return [List] A list of JSON objects for each profile with the id, email, phone number, and push token
    def self.get_group_members(list_id)
      path = "#{@@group}/#{list_id}/#{@@members}/#{@@all}"
      v2_request('GET', path)
    end
  end
end
