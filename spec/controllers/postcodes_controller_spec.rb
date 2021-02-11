require_relative '../spec_helper'
require_relative '../../app/services/postcodes_api/exceptions'
require_relative '../../app/services/postcodes_checker/exceptions'
require_relative '../../app/services/postcodes_checker/service'

module RSpecMixin
  def app
    PostcodesController
  end
end

describe PostcodesController do
  context "GET /check" do
    let(:postcode) { "MOCK CODE" }
    let(:sanitized_postcode) { Postcode.sanitize(postcode) }
    before(:each) do
      @service_checker_double = double("service_checker")
      PostcodesController.set(:service_checker, @service_checker_double)
    end

    context "when postcode is servicable" do
      it "returns 200 and renders the template with a service available message" do
        expected_message = "Service available for: '#{sanitized_postcode}'"
        expect(@service_checker_double).to(
          receive(:servicable?).
          with(sanitized_postcode).
          and_return(true))

        response = get "/check", {postcode: postcode}, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to include(expected_message)
      end

      context "when postcode is not servicable" do
        it "returns 200 and renders the template with a service unavailable message"do
        expected_message = "Service is not available for: '#{sanitized_postcode}'"
        expect(@service_checker_double).to(
          receive(:servicable?).
          with(sanitized_postcode).
          and_return(false))

        response = get "/check", {postcode: postcode}, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to include(expected_message)
        end
      end

      context "an error occurs" do
        context "PostcodeInvalid" do
          it "returns 400 and renders the template with the exception error message" do
            expected_message = "Error: Invalid postcode"
            expect(@service_checker_double).to(
              receive(:servicable?).
              with(sanitized_postcode).
              and_raise(PostcodesCheckerExceptions::PostcodeInvalid))

            response = get "/check", {postcode: postcode}, format: :json
            expect(response.status).to eq(400)
            expect(response.body).to include(expected_message)
          end
        end

        context "PostcodeNotFound" do
          it "returns 400 and renders the template with the exception error message" do
            expected_message = "Error: Postcode not found"
            expect(@service_checker_double).to(
              receive(:servicable?).
              with(sanitized_postcode).
              and_raise(PostcodesCheckerExceptions::PostcodeNotFound))

            response = get "/check", {postcode: postcode}, format: :json
            expect(response.status).to eq(404)
            expect(response.body).to include(expected_message)
          end
        end

        context "Server Error" do
          it "returns 500 and renders the template with the exception error message" do
            expected_message = "Internal server error"
            expect(@service_checker_double).to(
              receive(:servicable?).
              with(sanitized_postcode).
              and_raise(Errno::ETIMEDOUT))

            response = get "/check", {postcode: postcode}, format: :json
            expect(response.status).to eq(500)
            expect(response.body).to include(expected_message)
          end
        end
      end
    end
  end
end