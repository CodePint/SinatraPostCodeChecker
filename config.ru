require_relative './config/environment'
Dir.glob(File.expand_path("../app/**/*.rb", __FILE__)).each {|f| require_relative f }

run ApplicationController
use PostcodesController
