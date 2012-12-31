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

require './app/models/check.rb'
require './app/jobs/check_job.rb'

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

Dir["./app/jobs/*.rb"].each { |file| require file }

# if ENV['CHECK']
#   scheduler = Rufus::Scheduler::PlainScheduler.start_new
#   scheduler.every '3m', :first_in => '0s' do |newcheck|
#     puts "Loading new checks"
#     Check.where('loaded_by != ? OR loaded_by IS NULL',scheduler.object_id.to_s).each do |check|
#       puts "Adding #{check.url} (#{check.id})"
#       scheduler.every check.frequency || '3m', CheckJob.new(check), :first_in => '10s'
#       check.update_attribute(:loaded_by, scheduler.object_id.to_s)
#     end
#   end
# end

