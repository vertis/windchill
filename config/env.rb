require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require "sinatra/activerecord"
require 'resque_scheduler'
require 'eventmachine'
require 'pony'
require 'httparty'
require 'chronic'

require 'newrelic_rpm'

require 'honeybadger'

require './app/models/check.rb'
require './app/jobs/check_job.rb'
#Dir["./app/jobs/*.rb"].each { |file| require file }

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}


set :database, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my.db"


# resque scheduler
Resque.redis = ENV["REDISTOGO_URL"] || 'localhost:6379'
Resque.redis.namespace = "resque:windchill"

# If you want to be able to dynamically change the schedule,
# uncomment this line.  A dynamic schedule can be updated via the
# Resque::Scheduler.set_schedule (and remove_schedule) methods.
# When dynamic is set to true, the scheduler process looks for
# schedule changes and applies them on the fly.
# Note: This feature is only available in >=2.0.0.
Resque::Scheduler.dynamic = true
Resque.schedule = {}
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }

Honeybadger.configure do |config|
  config.api_key = ENV["HONEYBADGER_API_KEY"]
end
