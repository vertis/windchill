class Check < ActiveRecord::Base
  after_save :schedule
  
  def schedule
    Resque.remove_schedule("check-#{self.id}")
    Resque.set_schedule("check-#{self.id}", {  :class => 'CheckJob',
                                               :every => self.frequency || '10s',
                                               :first_in => '10s',
                                               :queue => 'high',
                                               :args => { :check_id => self.id} 
                                            }
                                  )
  end
end