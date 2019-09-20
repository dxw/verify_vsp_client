require "spec_helper"
require "verify_vsp_client/fake_sso"

RSpec.describe VerifyVspClient::FakeSso do
  include Rack::Test::Methods

  describe "POST to /verified" do
    let(:callback_url) { "/verify/response" }
    let(:app) { VerifyVspClient::FakeSso.new(callback_url) }
    let(:success_response) { VerifyVspClient::FakeSso::IDENTITY_VERIFIED_SAML_RESPONSE }

    it "returns a HTML form that will POST back to the app with a successful SAML response parameter" do
      post "/verified"

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq "text/html"
      expect(last_response.body).to include "<form action=\"#{callback_url}\" method=\"POST\" id=\"verify_auth_request\">"
      expect(last_response.body).to include "<input type=\"hidden\" name=\"SAMLResponse\" value=\"#{success_response}\">"
    end
  end
end
