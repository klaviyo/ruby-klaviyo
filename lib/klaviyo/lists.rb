require 'rest-client'

module Klaviyo
  module Lists

    def lists
      _RESOURCE = 'api/v1/lists'
      rest_client_request('GET', "#{_RESOURCE}?api_key=#{@api_key}")
    end

    def list(id = nil)
      raise KlaviyoError.new('You must pass a list ID') if id.nil?

      _RESOURCE = "api/v1/list/#{id}"
      rest_client_request('GET', "#{_RESOURCE}?api_key=#{@api_key}")
    end

    def add_member_to_list(id = nil, kwargs = {})
      raise KlaviyoError.new('You must pass a list  ID') if id.nil?
      raise KlaviyoError.new('You must pass an email') if kwargs[:email].to_s.empty?
      _RESOURCE = "api/v1/list/#{id}/members"

      params = {
          api_key: @api_key,
          email: kwargs[:email],
          properties: kwargs[:properties],
          confirm_optin: kwargs[:confirm_optin]
      }
      rest_client_request('POST', "#{_RESOURCE}", params)
    end

    def remove_member_from_list(id = nil, kwargs = {})
      raise KlaviyoError.new('You must pass a list  ID') if id.nil?
      raise KlaviyoError.new('You must pass an email') if kwargs[:email].to_s.empty?

      _RESOURCE = "api/v1/list/#{id}/members/batch"

      params = {
          api_key: @api_key,
          batch: ([ { email: kwargs[:email] } ]).to_json
      }
      rest_client_request('DELETE', "#{_RESOURCE}", params)
    end

    private

    def rest_client_request(method, resource, params = {})
      defined? method or raise(ArgumentError, 'Request method has not been specified')
      defined? resource or raise(ArgumentError, 'Request resource has not been specified')

      RestClient::Request.new({
                                  method: method,
                                  url: "#{@url}#{resource}",
                                  payload: params,
                                  headers: { accept: :json, content_type: :json }
                              }).execute do |response, request, result|
        JSON.parse(response.to_str)
      end
    end
  end
end
