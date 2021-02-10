require_relative '../helpers/postcode_helper'

class PostcodesController < ApplicationController
  helpers PostcodeHelper
  get "/" do
    @message = "PostcodesController"
    erb :index
  end
end
