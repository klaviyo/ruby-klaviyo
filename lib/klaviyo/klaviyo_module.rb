require 'open-uri'
require 'base64'
require 'json'
require 'faraday'

require_relative './client'
require_relative 'apis/public'
require_relative 'apis/lists'
require_relative 'apis/metrics'
require_relative 'apis/profiles'

module Klaviyo
  class << self
    attr_accessor :public_api_key
    attr_accessor :private_api_key
  end

  class KlaviyoError < StandardError; end

  NO_PRIVATE_API_KEY_ERROR = 'Please provide your Private API key for this request'
  NO_PUBLIC_API_KEY_ERROR = 'Please provide your Public API key for this request'
  REQUIRED_ARG_ERROR = 'You must identify a user by email, ID or phone_number'
end
