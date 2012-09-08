require 'data_mapper'
require 'dm-timestamps' # Create
require 'dm-transactions'

require 'yaml'
#dbConfig = YAML.load_file("config/database.yml")
env = ENV["RACK_ENV"] || "development"
#puts "Using database #{dbConfig[env][:database]}"
#DataMapper::Model.raise_on_save_failure = true
#DataMapper::Logger.new($stdout, :debug)
#DataMapper.setup(:default, dbConfig[env])
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')	
#DataMapper.setup(:default,DATABASE_URL)
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/development.sqlite3")

require_relative 'person'
require_relative 'teaser'

DataMapper.finalize

