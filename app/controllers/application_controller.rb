require_relative '../helpers/application_helper'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelper
  register Sinatra::ActiveRecordExtension

  # set views erb template directory
  set :views, File.expand_path("../views", __dir__)

  # enable logging for prod and dev
  configure :production, :development do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end
end
