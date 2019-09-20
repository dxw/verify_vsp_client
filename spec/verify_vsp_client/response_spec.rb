require "spec_helper"

RSpec.describe VerifyVspClient::Response, type: :model do
  subject { VerifyVspClient::Response.new(response) }
  let(:response) { JSON.parse File.read(File.join(base_dir, "fixtures", response_filename)) }

  describe ".translate" do
    let(:saml_response) { example_vsp_translate_request_payload.fetch("samlResponse") }
    let(:request_id) { example_vsp_translate_request_payload.fetch("requestId") }
    let(:level_of_assurance) { example_vsp_translate_request_payload.fetch("levelOfAssurance") }

    it "returns a VerifyVspClient::Response with the results of the translation from the ServiceProvider" do
      stub_vsp_translate_response_request

      verify_response = VerifyVspClient::Response.translate(saml_response: saml_response, request_id: request_id, level_of_assurance: level_of_assurance)

      expect(verify_response).to be_kind_of(VerifyVspClient::Response)
      expect(verify_response).to be_verified
    end
  end

  context "with a verified response" do
    let(:response_filename) { "identity-verified.json" }

    it "is verified" do
      expect(subject.verified?).to eq(true)
    end
  end

  context "with a cancelled response" do
    let(:response_filename) { "no-authentication.json" }

    it "is not verified" do
      expect(subject.verified?).to eq(false)
    end
  end

  context "with a failed response" do
    let(:response_filename) { "authentication-failed.json" }

    it "is not verified" do
      expect(subject.verified?).to eq(false)
    end
  end

  context "with an errored response" do
    let(:response_filename) { "error.json" }

    it "is not verified" do
      expect(subject.verified?).to eq(false)
    end
  end
end
