class HttpCheckException < Exception; end

class CheckJob
  @queue = :high

  def self.perform(args)
    raise args.inspect
  end
end
# 
# class CheckJob
#   def initialize(check)
#     @check = check
#   end
#   
#   def call(job)
#     begin
#       res = HTTParty.head(@check.url)
#       raise HttpCheckException.new("App down") unless res.success?
#       handle_success
#     rescue SocketError, Errno::ECONNREFUSED, HttpCheckException => ex
#       handle_failure
#     end
#     @check.update_attribute(:last_checked, Time.now)
#   end
#   
#   def handle_success
#     if @check.fail_count >= @check.fail_limit
#       send_recovery
#       @check.fail_count = 0
#       @check.last_notified = nil
#       @check.save
#     end
#   end
#   
#   def handle_failure
#     @check.fail_count += 1
#     @check.save
#     send_alert if @check.fail_count >= @check.fail_limit
#   end
#   
#   def send_alert
#     if @check.last_notified.nil? || @check.last_notified <= Chronic.parse('10 minutes ago')
#       Pony.mail(:to => 'luke.a.chadwick@gmail.com', 
#                 :from => 'luke.a.chadwick@gmail.com', 
#                 :subject => "[windchill] Your app #{@check.url} is down", 
#                 :body => "Your app #{@check.url} is down")
#        @check.last_notified = Time.now
#        @check.save
#     end
#   end
#   
#   def send_recovery
#     Pony.mail(:to => 'luke.a.chadwick@gmail.com', :from => 'luke.a.chadwick@gmail.com', :subject => "[windchill] Your app #{@check.url} has recovered", :body => "Your app #{@check.url} has recovered")
#   end
# end