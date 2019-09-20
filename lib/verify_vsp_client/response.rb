module VerifyVspClient
  # Represents a Response from a Verify authentication attempt.
  #
  # Use by calling VerifyVspClient::Response.translate to translate a SAML response using
  # the Verify Service Provider, for example:
  #
  #   VerifyVspClient::Response.translate(saml_response: "SOME SAML", request_id: "REQUEST_ID", level_of_assurance: "LEVEL_2")
  #
  class Response
    class MissingResponseAttribute < StandardError; end
    attr_reader :parameters

    def initialize(parameters)
      @parameters = parameters
    end

    def self.translate(saml_response:, request_id:, level_of_assurance:)
      parameters = VerifyVspClient::ServiceProvider.new.translate_response(saml_response, request_id, level_of_assurance)
      new(parameters)
    end

    def verified?
      scenario == VerifyVspClient::IDENTITY_VERIFIED_SCENARIO
    end

    def scenario
      @scenario ||= parameters["scenario"]
    end
  end
end
