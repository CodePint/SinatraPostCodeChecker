class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  # set views erb template directory
  set :views, File.expand_path('../views', __dir__)

  # enable logging for prod and dev
  configure :production, :development do
    enable :logging
  end
end
