require "active_support"
require "active_support/core_ext"

require_relative "verify_vsp_client/version"
require_relative "verify_vsp_client/service_provider"
require_relative "verify_vsp_client/authentication_request"
require_relative "verify_vsp_client/redacted_response"
require_relative "verify_vsp_client/response"
require_relative "verify_vsp_client/response_error"

module VerifyVspClient
  IDENTITY_VERIFIED_SCENARIO = "IDENTITY_VERIFIED".freeze
  AUTHENTICATION_FAILED_SCENARIO = "AUTHENTICATION_FAILED".freeze
  NO_AUTHENTICATION_SCENARIO = "NO_AUTHENTICATION".freeze

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :vsp_host
  end
end
