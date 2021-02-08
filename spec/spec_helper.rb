ENV["RACK_ENV"] = "test"

require 'rspec'
require 'rack/test'
require_relative '../config/environment'

module RSpecMixin
  include Rack::Test::Methods

  def app
    ApplicationController
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    Rake::Task['db:reset'].invoke()
  end
end