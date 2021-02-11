require_relative '../models/postcode'
require_relative '../helpers/postcodes_helper'
require_relative '../services/postcodes_api/client'
require_relative '../services/postcodes_checker/service'

class PostcodesController < ApplicationController
  include PostcodesApiExceptions
  include PostcodesCheckerExceptions

  helpers PostcodesHelper
  set :api_client, PostcodesAPI::Client.new
  set :service_checker, PostcodesChecker::Service.new(api_client)

  get "/" do
    erb :index
  end

  get "/check" do
    begin
      @postcode = Postcode.sanitize(params[:postcode])
      @servicable = service_checker.servicable?(@postcode)
    rescue PostcodeInvalid => @error
      status 400
    rescue PostcodeNotFound => @error
      status 404
    rescue StandardError
      @error = "Internal server error"
      status 500
    end
    erb :index
  end
end
