require_relative '../../spec_helper'
require_relative '../services_spec_helpers'
require_relative '../../../app/services/postcodes_checker/exceptions'
require_relative '../../../app/services/postcodes_api/client'
require_relative '../../../app/services/postcodes_api/exceptions'

RSpec.configure do |c|
  c.include ServicesSpecHelpers
end

describe PostcodesAPI do
  describe PostcodesAPI::Client do
    let(:api_uri) { ENV["POSTCODES_API_PRIMARY_URI"] }
    let(:client) { PostcodesAPI::Client.new(api_uri) }

    let(:found_postcode) { "SE17QD" }
    let(:invalid_postcode) { "S£19%D" }
    let(:not_found_postcode) { "SE19QD" }

    context "#request" do
      let(:endpoint) { "#{api_uri}/test" }
      let(:params) { {k: "v"} }

      context "when the request is successful" do
        it "returns the parsed json data" do
          stub_request(:get, /#{endpoint}.*/)
            .with(query: params)
            .to_return(body: JSON.dump(success_response), status: 200)

          data = client.send("request", verb: :get, endpoint: endpoint, params: params)
          expect(data).to eq(success_response)
        end
      end

      context "when the request returns an error" do
        it "raises BadRequestError when the staus is 400" do
          stub_request(:get, /#{endpoint}.*/)
            .with(query: params)
            .to_return(body: JSON.dump(bad_request_response), status: 400)

          expect {
            client.send("request", verb: :get, endpoint: endpoint, params: params)
          }.to raise_error(PostcodesApiExceptions::BadRequestError)
        end

        it "raises NotFoundError when the status is 404" do
          stub_request(:get, /#{endpoint}.*/)
            .with(query: params)
            .to_return(body: JSON.dump(not_found_response), status: 404)

          expect {
            client.send("request", verb: :get, endpoint: endpoint, params: params)
          }.to raise_error(PostcodesApiExceptions::NotFoundError)
        end

        it "raises InternalServerError when the status is 500" do
          stub_request(:get, /#{endpoint}.*/)
            .with(query: params)
            .to_return(body: JSON.dump(internal_server_error_response), status: 500)

          expect {
            client.send("request", verb: :get, endpoint: endpoint, params: params)
          }.to raise_error(PostcodesApiExceptions::InternalServerError)
        end

        it "raises PostcodesApiClientError when the status is not 200, 400, 404, 500" do
          stub_request(:get, /#{endpoint}.*/)
            .with(query: params)
            .to_return(body: JSON.dump(error_response(404, "Forbidden")), status: 400)

          expect {
            client.send("request", verb: :get, endpoint: endpoint, params: params)
          }.to raise_error(PostcodesApiExceptions::PostcodesApiClientError)
        end
      end
    end

    context "#lookup_postcode" do
      let(:endpoint) { "#{api_uri}/postcodes" }
      context "when a matching postcode is found" do
        let(:expected_response) { postcode_lookup_response(found_postcode) }
        it "calls the endpoint and returns the parsed json data" do
          stub_request(:get, "#{endpoint}/#{found_postcode}")
            .to_return(body: JSON.dump(expected_response), status: 200)

          data = client.lookup_postcode(found_postcode)
          expect(data).to eq(expected_response)
        end
      end

      context "when postcode is not found" do
        it "raises PostcodeNotFound" do
          error_message = "Postcode not found"
          stub_request(:get, "#{endpoint}/#{not_found_postcode}")
            .to_return(body: JSON.dump(not_found_response(error_message)), status: 404)

          expect {
            client.lookup_postcode(not_found_postcode)
          }.to raise_error(PostcodesCheckerExceptions::PostcodeNotFound)
        end
      end

      context "when the postcode is invalid" do
        it "raises PostcodeInvalid" do
          error_message = "Invalid postcode"
          stub_request(:get, "#{endpoint}/#{invalid_postcode}")
            .to_return(body: JSON.dump(not_found_response(error_message)), status: 404)

          expect {
            client.lookup_postcode(invalid_postcode)
          }.to raise_error(PostcodesCheckerExceptions::PostcodeInvalid)
        end
      end
    end
  end
end
