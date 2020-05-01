class Check < ActiveRecord::Base
  after_save :schedule
  before_destroy :remove_from_schedule
  
  def schedule
    Resque.remove_schedule("check-#{self.id}")
    Resque.set_schedule("check-#{self.id}", {  :class => 'CheckJob',
                                               :every => self.frequency || '3m',
                                               :first_in => '10s',
                                               :queue => 'high',
                                               :args => { :check_id => self.id} 
                                            }
                                  )
  end
  
  def remove_from_schedule
    Resque.remove_schedule("check-#{self.id}")
  end
end