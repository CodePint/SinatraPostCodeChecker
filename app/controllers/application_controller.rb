require 'action_view'
require_relative '../helpers/application_helper'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelper
  helpers ActionView::Helpers::FormTagHelper

  register Sinatra::ActiveRecordExtension

  # set views erb template directory
  set :views, File.expand_path("../views", __dir__)

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
    erb :'application/test'
  end
end
