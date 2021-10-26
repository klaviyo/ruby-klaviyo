module Klaviyo
  class Campaigns < Client
    CANCEL = 'cancel'
    CAMPAIGN = 'campaign'
    CAMPAIGNS = 'campaigns'
    SEND = 'send'

     # Retrieves all the campaigns from Klaviyo account
     # @kwarg :api_key [String] private API key for this request
     # @return [List] of JSON formatted campaing objects
    def self.get_campaigns(api_key: nil)
      v1_request(HTTP_GET, CAMPAIGNS, api_key: api_key)
    end

    # Retrieves the details of the list
    # @param campaign_id the if of campaign
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing information about the campaign
    def self.get_campaign_details(campaign_id, api_key: nil)
      path = "#{CAMPAIGN}/#{campaign_id}"

      v1_request(HTTP_GET, path, api_key: api_key)
    end

    # Sends the campaign immediately
    # @param campaign_id [String] the id of campaign
    # @kwarg :api_key [String] private API key for this request
    # @return will return with HTTP ok in case of success
    def self.send_campaign(campaign_id, api_key: nil)
      path = "#{CAMPAIGN}/#{campaign_id}/#{SEND}"

      v1_request(HTTP_POST, path, api_key: api_key)
    end

    # Cancels the campaign with specified campaign_id
    # @param campaign_id [String] the id of campaign
    # @kwarg :api_key [String] private API key for this request
    # @return [JSON] a JSON object containing the campaign details
    def self.cancel_campaign(campaign_id, api_key: nil)
      path = "#{CAMPAIGN}/#{campaign_id}/#{CANCEL}"

      v1_request(HTTP_POST, path, api_key: api_key)
    end
  end
end
