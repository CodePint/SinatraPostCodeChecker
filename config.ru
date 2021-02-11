require_relative './config/environment'

map("/") { run ApplicationController }
map("/postcodes") { run PostcodesController }
