class PostcodesController < ApplicationController
  get '/' do
    @message = "PostcodesController"
    erb :'postcodes/index'
  end
end
