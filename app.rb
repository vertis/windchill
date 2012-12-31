require './config/env.rb'

configure :production do
  require 'newrelic_rpm'
end

get '/' do
  "Hello World!"
end