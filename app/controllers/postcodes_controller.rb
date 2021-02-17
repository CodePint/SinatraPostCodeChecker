require_relative '../models/postcode'
require_relative '../helpers/postcodes_helper'
require_relative '../services/postcodes_api/client'
require_relative '../services/postcodes_checker/service'

class PostcodesController < ApplicationController
  include PostcodesApiExceptions
  include PostcodesCheckerExceptions

  helpers PostcodesHelper
  set :service_checker, PostcodesChecker::Service.new(
    primary_client: PostcodesAPI::Client.new(ENV["POSTCODES_API_PRIMARY_URI"]),
    backup_client:  PostcodesAPI::Client.new(ENV["POSTCODES_API_BACKUP_URI"])
  )

  get "/" do
    erb :index
  end

  get "/check" do
    begin
      @postcode = Postcode.sanitize(params[:postcode])
      @servicable = service_checker.servicable?(@postcode)
    rescue PostcodesServiceCheckerError => @error
      status POSTCODES_HTTP_EXCEPTIONS[@error.class]
    rescue StandardError
      @error = "Internal server error"
      status 500
    end

    erb :index
  end
end
