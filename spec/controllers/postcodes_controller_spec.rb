# require_relative '../spec_helper'
# require_relative '../../app/services/postcodes_checker/service'

# describe ApplicationController do
#   context "GET /check" do
#     let(:postcode) { "MOCK CODE" }
#     before(:each) do
#       service_checker_double = double("service_checker")
#       allow(PostcodesChecker::Service).to receive(:new).and_return(service_checker_double)
#       expect(service_checker_double).to receive(:servicable?).with(Postcode.sanitize(postcode))
#       require_relative '../../app/controllers/postcodes_controller'
#     end

#     context "when postcode is servicable" do
#       it "returns 200 and renders the index template with a service available message" do
#         expected_message = "Service available for: #{postcode}"
#         binding.pry
#         response = get "/check", {postcode: postcode}, format: :json
#         # expect(response.body).to include(params[:message])
#       end

#     #   context "when postcode is not servicable" do
#     #     it "returns 200 and renders the index template with a service unavailable message"do
#     #       expected_message = "Service unavailable for: #{postcode}"
#     #       response = get "/check", {postcode: postcode}, format: :json
#     #       # expect(response.body).to include(params[:message])
#     #     end
#     #   end

#     #   context "an error occurs" do
#     #     it "renders the test template with the message param" do

#     #     end
#     #   end
#     end
#   end
# end