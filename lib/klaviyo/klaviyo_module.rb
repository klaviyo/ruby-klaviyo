require 'open-uri'
require 'base64'
require 'json'
require 'faraday'

module Klaviyo
  NO_PRIVATE_API_KEY_ERROR = 'Please provide your Private API key for this request'
  NO_PUBLIC_API_KEY_ERROR = 'Please provide your Public API key for this request'
  REQUIRED_ARG_ERROR = 'You must identify a user by email, ID or phone_number'
  INVALID_ID_TYPE_ERROR = 'Invalid id_type provided, must be one of: email, phone_number, person_id'

  class << self
    attr_accessor :public_api_key
    attr_accessor :private_api_key
  end

  class KlaviyoError < StandardError; end

  autoload :Client,         'klaviyo/client'
  autoload :Public,         'klaviyo/apis/public'
  autoload :Lists,          'klaviyo/apis/lists'
  autoload :Metrics,        'klaviyo/apis/metrics'
  autoload :Profiles,       'klaviyo/apis/profiles'
  autoload :Campaigns,      'klaviyo/apis/campaigns'
  autoload :EmailTemplates, 'klaviyo/apis/email_templates'
  autoload :DataPrivacy,    'klaviyo/apis/data_privacy'
end
