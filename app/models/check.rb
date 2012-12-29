class Check
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :required => true
end