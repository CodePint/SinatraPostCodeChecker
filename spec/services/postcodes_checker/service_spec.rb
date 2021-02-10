require_relative '../../spec_helper'
require_relative '../services_spec_helpers'
require_relative '../../../app/services/postcodes_checker/service'
require_relative '../../../app/services/postcodes_checker/exceptions'
require_relative '../../../app/services/postcodes_api/exceptions'

RSpec.configure do |c|
  c.include ServicesSpecHelpers
end

describe PostcodesChecker do
  let(:api_uri) { ENV["POSTCODES_API_BASE_URI"] }
  let(:endpoint) { "#{api_uri}/postcodes" }
  let(:service_checker) { PostcodesChecker::Service.new(PostcodesAPI::Client.new)}

  let(:invalid_postcode) { "S£19%D" }
  let(:allowed_postcode) { "SH24 1AB " }
  let(:not_found_postcode) { "SE19QD" }
  let(:not_allowed_postcode) { "SE1 7QD" }
  let(:allowed_lsoa) { "Southwark" }
  let(:not_allowed_lsoa) { "NotAllowedLsoa" }

  describe PostcodesChecker::Service do
    describe "#servicable?" do
      context "when the postcode is invalid" do
        it 'raises PostcodeInvalid' do
          expect {
            service_checker.servicable?(invalid_postcode)
          }.to raise_error(PostcodesCheckerExceptions::PostcodeInvalid)
        end
      end

      context "when the postcode is allowed" do
        it 'returns true' do
          expect(service_checker.servicable?(allowed_postcode)).to be true
        end
      end

      context "when the postcode is not found" do
        it "returns false" do
          error_message = "Postcode not found"
          stub_request(:get, "#{endpoint}/#{not_found_postcode}").
            to_return(body: JSON.dump(not_found_response(error_message)), status: 404)

            expect {
              service_checker.servicable?(not_found_postcode)
            }.to raise_error(PostcodesCheckerExceptions::PostcodeNotFound)
        end
      end

      context "when the LSOA is allowed" do
        let(:client_response) { postcode_lookup_response(not_allowed_postcode, allowed_lsoa) }
        it 'returns true' do
          stub_request(:get, "#{endpoint}/#{not_found_postcode}").
            to_return(body: JSON.dump(client_response), status: 200)

            expect(service_checker.servicable?(not_found_postcode)).to be true
        end
      end

      context "when both the postcode and the LSOA are not allowed" do
        let(:client_response) { postcode_lookup_response(not_found_postcode, not_allowed_lsoa) }
        it 'retuns false' do
            stub_request(:get, "#{endpoint}/#{not_found_postcode}").
              to_return(body: JSON.dump(client_response), status: 200)

          expect(service_checker.servicable?(not_found_postcode)).to be false
        end
      end

      context "when the client request returns postcode invalid" do
        it "raises PostcodeInvalid" do
          error_message = "Invalid postcode"
          stub_request(:get, "#{endpoint}/#{invalid_postcode}").
          to_return(body: JSON.dump(not_found_response(error_message)), status: 404)

          expect {
            service_checker.servicable?(invalid_postcode)
          }.to raise_error(PostcodesCheckerExceptions::PostcodeInvalid)
        end
      end
    end
  end
end