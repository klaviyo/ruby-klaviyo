module Klaviyo
  class DataPrivacy < Client
    DATA_PRIVACY = 'data-privacy'
    DELETETION_REQUEST = 'deletion-request'

    # Submits a data privacy-related deletion request
    # @param identified [Hash] a hash containing either email, phone_number or person_id
    # @return will return with HTTP OK on success
    def self.deletion_request(kwargs = {})
      check_required_args(kwargs)

      identifier = { phone_number: kwargs[:phone_number] } if kwargs[:phone_number]
      identifier = { email: kwargs[:email] } if kwargs[:email]
      identifier = { person_id: kwargs[:id] } if kwargs[:id]

      path = "#{DATA_PRIVACY}/#{DELETETION_REQUEST}"
      v2_request(HTTP_POST, path, identifier)
    end
  end
end
