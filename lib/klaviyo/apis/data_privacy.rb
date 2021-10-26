module Klaviyo
  class DataPrivacy < Client
    DATA_PRIVACY = 'data-privacy'
    DELETION_REQUEST = 'deletion-request'

    # Submits a data privacy-related deletion request
    # @param id_type [String] 'email' or 'phone_number' or 'person_id
    # @param identifier [String] value for the identifier specified
    # @kwarg :api_key [String] private API key for this request
    # @return a dictionary with a confirmation that deletion task submitted for the customer
    def self.request_profile_deletion(id_type, identifier, api_key: nil)
      unless ['email', 'phone_number', 'person_id'].include? id_type
        raise Klaviyo::KlaviyoError.new(INVALID_ID_TYPE_ERROR)
      end
      data = Hash[id_type.to_sym, identifier]
      path = "#{DATA_PRIVACY}/#{DELETION_REQUEST}"
      v2_request(HTTP_POST, path, api_key: api_key, **data)
    end
  end
end
