ENV["RACK_ENV"] = "test"
ENV["POSTCODES_API_BASE_URI"] = "http://postcodes-testing.io"

require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require_relative '../config/environment'


module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    Rake::Task["db:reset"].invoke
  end
end
