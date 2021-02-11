require_relative '../spec_helper'

module RSpecMixin
  def app
    ApplicationController
  end
end

describe ApplicationController do
  context "GET /test" do
    it "renders the test template with the message param" do
      params = {message: "world"}
      response = get "/test", params, format: :json
      expect(response.body).to include(params[:message])
    end
  end
end