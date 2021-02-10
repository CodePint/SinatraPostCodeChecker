require 'action_view'
require 'active_support'
require_relative '../models/postcode'
require_relative '../helpers/postcode_helper'
require_relative '../services/postcodes_api/client'
require_relative '../services/postcodes_checker/service'
require 'pry'

class PostcodesController < ApplicationController
  include PostcodesApiExceptions, PostcodesCheckerExceptions
  helpers ApplicationHelper
  register Sinatra::ActiveRecordExtension

  api_client = PostcodesAPI::Client.new
  service_checker = PostcodesChecker::Service.new(api_client)

  get "/" do
    erb :index
  end

  get "/check" do
    @postcode = Postcode.sanitize(params[:postcode])
    begin
      @servicable = service_checker.servicable?(@postcode)
    rescue PostcodeNotFound => @error
      status 400
    rescue PostcodeInvalid => @error
      status 404
    rescue StandardError
      @error = "Internal server error"
      status 500
    end

    erb :index
  end

end
