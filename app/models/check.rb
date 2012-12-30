class Check
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :required => true
  property :frequency, String
  property :state, String
  property :last_notified, Time
  property :last_checked, Time
  property :fail_count, Integer, :default => 0
  property :fail_limit, Integer, :default => 3
  property :loaded_by, String
end