require_relative '../helpers/application_helper'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  # set views erb template directory
  set :views, File.expand_path("../views", __dir__)
  set :public_folder, File.expand_path('../../public', __dir__)

  # enable logging for development and production
  configure :development, :production do
    enable :logging
  end

  # configure automatic code reloading for development
  configure :development do
    register Sinatra::Reloader
  end

  # dummy route
  get "/test" do
    @message = params["message"]
    erb :test
  end
end
