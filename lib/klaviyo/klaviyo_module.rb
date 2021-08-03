require 'open-uri'
require 'base64'
require 'json'
require 'faraday'

require_relative './client'
require_relative 'apis/public'
require_relative 'apis/lists'
require_relative 'apis/metrics'
require_relative 'apis/profiles'
require_relative 'apis/campaigns'
require_relative 'apis/email_templates'
require_relative 'apis/data_privacy'

module Klaviyo
  class << self
    attr_accessor :public_api_key
    attr_accessor :private_api_key
  end

  class KlaviyoError < StandardError; end

  NO_PRIVATE_API_KEY_ERROR = 'Please provide your Private API key for this request'
  NO_PUBLIC_API_KEY_ERROR = 'Please provide your Public API key for this request'
  REQUIRED_ARG_ERROR = 'You must identify a user by email, ID or phone_number'
  INVALID_ID_TYPE_ERROR = 'Invalid id_type provided, must be one of: email, phone_number, person_id'
  PRIVATE_KEY_AS_PUBLIC = 'Private API key added in place of Public API key'
  INCORRECT_PUBLIC_API_KEY_LENGTH = 'Public API Key must be 6 characters'
  INVALID_HTTP_METHOD = 'Invalid HTTP method present, please use "get" or "post"'
end
