require 'sinatra/base'
require 'active_support'

# require controller and helper files
Dir.glob('app/helpers/*.rb').sort.each {|file| require_relative file }
Dir.glob('app/controllers/*.rb').sort.each {|file| require_relative file }

# configure controller route prefixes
map('/') { run ApplicationController }
map('/') { run PostcodesController }