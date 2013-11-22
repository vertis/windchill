class HttpCheckException < Exception; end

class GithubStreakJob
  @queue = :high

  def self.perform(args)
    self.new.check
  end
  
  def check
    # Check GitHub for whether anything has been performed today
  end
  
  def handle_success
    # if @check.fail_count >= @check.fail_limit
    #   send_recovery
    #   @check.fail_count = 0
    #   @check.last_notified = nil
    #   @check.save
    # end
  end
  
  def handle_failure
    # @check.fail_count += 1
    # @check.save
    # send_alert if @check.fail_count >= @check.fail_limit
  end
  
  def send_alert
    # if @check.last_notified.nil? || @check.last_notified <= Chronic.parse('10 minutes ago')
    #   Pony.mail(:to => ENV['NOTIFY_EMAIL'], 
    #             :from => ENV['NOTIFY_EMAIL'], 
    #             :subject => "[windchill] Your github streak is in danger", 
    #             :body => "Your github streak is in danger")
    #    @check.last_notified = Time.now
    #    @check.save
    # end
  end
  
  def send_recovery
    #Pony.mail(:to => ENV['NOTIFY_EMAIL'], :from => ENV['NOTIFY_EMAIL'], :subject => "[windchill] Your github streak is now safe", :body => "Your github streak is now safe")
  end
end