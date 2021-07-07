ENV["RACK_ENV"] = "test"

require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require_relative '../config/environment'

ENV["POSTCODES_API_PRIMARY_URI"] = "http://postcodes.io"
ENV["POSTCODES_API_BACKUP_URI"] = "http://postcodes.r.us"

module RSpecMixin
  include Rack::Test::Methods
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    Rake::Task["db:reset"].invoke
  end
end
