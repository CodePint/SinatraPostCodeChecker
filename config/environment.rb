ENV["SINATRA_ENV"] ||= "development"

Dir.glob(File.expand_path("../app/**/*.rb", __FILE__)).each {|f| require_relative f }

require 'bundler/setup'
Bundler.require

configure do
  set :database_file, "../config/database.yml"
end
