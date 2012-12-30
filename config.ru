require './app'
require 'resque/server'
require 'resque_scheduler/server'

run Rack::URLMap.new \
  "/"       => Sinatra::Application,
  "/resque" => Resque::Server.new