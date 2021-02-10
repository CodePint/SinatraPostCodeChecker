require_relative '../helpers/postcode_helper'
require_relative '../services/postcodes_api/client'
require_relative '../services/postcodes_checker/service'

class PostcodesController < ApplicationController
  helpers ApplicationHelper

  @api_client = PostcodesAPI::Client.new
  @service_checker = PostcodesChecker::Service.new(@api_client)

  get "/" do
    @message = "PostcodesController"
    erb :index
  end

end
