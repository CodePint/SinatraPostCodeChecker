require_relative '../../spec_helper'
require_relative '../services_spec_helpers'
require_relative '../../../app/services/postcodes_checker/service'
require_relative '../../../app/services/postcodes_checker/exceptions'
require_relative '../../../app/services/postcodes_api/exceptions'


RSpec.configure do |c|
  c.include ServicesSpecHelpers
end

describe PostcodesChecker do
  let(:primary_api) { ENV["POSTCODES_API_PRIMARY_URI"] }
  let(:backup_api) { ENV["POSTCODES_API_BACKUP_URI"] }
  let(:primary_endpoint) { "#{primary_api}/postcodes" }
  let(:backup_endpoint) { "#{backup_api}/postcodes" }

  let(:service_checker) { PostcodesChecker::Service.new }
  let(:invalid_postcode) { "S£19%D" }
  let(:allowed_postcode) { "SH24 1AB " }
  let(:not_found_postcode) { "SE19QD" }
  let(:not_allowed_postcode) { "SE17QD" }
  let(:allowed_lsoa) { "Southwark" }
  let(:not_allowed_lsoa) { "NotAllowedLsoa" }



  describe PostcodesChecker::Service do

    def backup_lookup_response(postcode=nil, district=nil)
      {
        "results" => [
          {"postcode" => postcode, "district" => district, "flat" => 1},
          {"postcode" => postcode, "district" => district, "flat" => 2}
        ]
      }
    end

    describe "#servicable?" do

      context "local checks" do
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
      end

      context "remote_checks" do
        context "when the primary api can be reached" do
          context "when the postcode is not found" do
            it "returns false" do
              error_message = "Postcode not found"
              stub_request(:get, "#{primary_endpoint}/#{not_found_postcode}")
                .to_return(body: JSON.dump(not_found_response(error_message)), status: 404)

              expect {
                service_checker.servicable?(not_found_postcode)
              }.to raise_error(PostcodesCheckerExceptions::PostcodeNotFound)
            end
          end

          context "when the LSOA is allowed" do
            let(:client_response) { postcode_lookup_response(not_allowed_postcode, allowed_lsoa) }
            it 'returns true' do
              stub_request(:get, "#{primary_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump(client_response), status: 200)

              expect(service_checker.servicable?(not_allowed_postcode)).to be true
            end
          end

          context "when both the postcode and the LSOA are not allowed" do
            let(:client_response) { postcode_lookup_response(not_found_postcode, not_allowed_lsoa) }
            it 'retuns false' do
              stub_request(:get, "#{primary_endpoint}/#{not_found_postcode}")
                .to_return(body: JSON.dump(client_response), status: 200)

              expect(service_checker.servicable?(not_found_postcode)).to be false
            end
          end

          context "when the client request returns postcode invalid" do
            it "raises PostcodeInvalid" do
              error_message = "Invalid postcode"
              stub_request(:get, "#{primary_endpoint}/#{invalid_postcode}")
                .to_return(body: JSON.dump(not_found_response(error_message)), status: 404)

              expect {
                service_checker.servicable?(invalid_postcode)
              }.to raise_error(PostcodesCheckerExceptions::PostcodeInvalid)
            end
          end
        end

        context "when the primary api cannot be reached" do
          context "when the backup api is successful" do
            it 'returns true' do
              stub_request(:get, "#{primary_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump(internal_server_error_response), status: 500)
              stub_request(:get, "#{backup_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump(backup_lookup_response(not_allowed_postcode, allowed_lsoa)), status: 200)

              expect(service_checker.servicable?(not_allowed_postcode)).to be true
            end

            it 'returns false' do
              stub_request(:get, "#{primary_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump(internal_server_error_response), status: 500)
              stub_request(:get, "#{backup_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump(backup_lookup_response(not_allowed_postcode, not_allowed_lsoa)), status: 200)

              expect(service_checker.servicable?(not_allowed_postcode)).to be false
            end
          end

          context "when the backup api is unsuccessful" do
            it 'raises the client exception' do
              stub_request(:get, "#{primary_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump(internal_server_error_response), status: 500)
              stub_request(:get, "#{backup_endpoint}/#{not_allowed_postcode}")
                .to_return(body: JSON.dump({"error" => "Internal server error"}), status: 500)

              expect {
                service_checker.servicable?(not_allowed_postcode)
              }.to raise_error(PostcodesApiExceptions::InternalServerError)
            end
          end
        end

      end
    end
  end
end
