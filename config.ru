require './app'
require 'resque/server'
require 'resque_scheduler/server'

use Honeybadger::Rack
run Rack::URLMap.new \
  "/"       => Sinatra::Application,
  "/resque" => Resque::Server.new