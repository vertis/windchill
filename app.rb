require './config/env.rb'

set :root, File.dirname(__FILE__)
set :public_folder, Proc.new { File.join(root, "public") }

configure :production do
  require 'newrelic_rpm'
end

get '/' do
  "Hello World!"
end