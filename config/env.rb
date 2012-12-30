require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'data_mapper'
require 'rufus/scheduler'
require 'eventmachine'
require 'pony'
require 'httparty'
require 'chronic'

require './app/models/check.rb'


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


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my.db")
DataMapper.auto_upgrade!

class HttpCheckException < Exception; end

class CheckJob
  def initialize(check)
    @check = check
  end
  
  def call(job)
    begin
      res = HTTParty.head(@check.url)
      raise HttpCheckException.new("App down") unless res.success?
      handle_success
    rescue SocketError, Errno::ECONNREFUSED, HttpCheckException => ex
      handle_failure
    end
    @check.update_attribute(:last_checked, Time.now)
  end
  
  def handle_success
    if @check.fail_count >= @check.fail_limit
      send_recovery
      @check.fail_count = 0
      @check.last_notified = nil
      @check.save
    end
  end
  
  def handle_failure
    @check.fail_count += 1
    @check.save
    send_alert if @check.fail_count >= @check.fail_limit
  end
  
  def send_alert
    if @check.last_notified.nil? || @check.last_notified <= Chronic.parse('10 minutes ago')
      Pony.mail(:to => 'luke.a.chadwick@gmail.com', 
                :from => 'luke.a.chadwick@gmail.com', 
                :subject => "[windchill] Your app #{@check.url} is down", 
                :body => "Your app #{@check.url} is down")
       @check.last_notified = Time.now
       @check.save
    end
  end
  
  def send_recovery
    Pony.mail(:to => 'luke.a.chadwick@gmail.com', :from => 'luke.a.chadwick@gmail.com', :subject => "[windchill] Your app #{@check.url} has recovered", :body => "Your app #{@check.url} has recovered")
  end
end


unless ENV['DONT_CHECK']
  scheduler = Rufus::Scheduler::PlainScheduler.start_new
  scheduler.every '3m', :first_in => '0s' do |newcheck|
    puts "Loading new checks"
    Check.all(:loaded_by.not => scheduler.object_id).each do |check|
      puts "Adding #{check.url} (#{check.id})"
      scheduler.every check.frequency || '3m', CheckJob.new(check), :first_in => '10s'
      check.update_attribute(:loaded_by, scheduler.object_id)
    end
  end
end

