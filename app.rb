require 'rubygems'
require 'bundler/setup'
require 'sinatra'

require 'data_mapper'
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my.db")

class Check
  include DataMapper::Resource

  property :id, Serial
  property :url, String, :required => true
end

DataMapper.auto_upgrade!

get '/' do
  "Hello World!"
end