require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'data_mapper'

require './app/models/check.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my.db")
DataMapper.auto_upgrade!