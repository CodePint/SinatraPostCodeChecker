class PostcodesController < ApplicationController
  get '/' do
    @message = "PostcodesController"
    erb :index
  end
end
