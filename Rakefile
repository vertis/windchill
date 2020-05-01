require './config/env'
require "sinatra/activerecord/rake"
require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" do
    ENV['TERM_CHILD'] = '1' 
    ENV['QUEUE'] = '*'
    
    Check.all.each do |check|
      check.schedule
    end
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
