require 'open-uri'
require 'base64'
require 'json'
require 'faraday'

require_relative './client'
require_relative 'apis/identify'
require_relative 'apis/lists'
require_relative 'apis/metrics'
require_relative 'apis/profiles'
require_relative 'apis/track'

module Klaviyo
  class << self
    attr_accessor :api_key
    attr_accessor :private_api_key
  end

  class KlaviyoError < StandardError; end

  NO_PRIVATE_API_KEY_ERROR = 'Please provide Private API key for this request'
end
