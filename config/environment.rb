ENV["RACK_ENV"] ||= "development"

## require order important due to sinatra-contrib/rake conflict
## see: https://stackoverflow.com/questions/30656858/66110634
require 'rake'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

require 'bundler/setup'
Bundler.require

require_all 'app'

configure do
  set :database_file, "../config/database.yml"
end
