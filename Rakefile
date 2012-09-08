require 'rake'

ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?

# DB tasks
namespace :db do
  require 'dm-core'
  require 'dm-types'
  require 'dm-timestamps'
  require 'dm-constraints'
  require 'dm-validations'
  require 'dm-migrations'
  require 'dm-serializer'
  require 'dm-transactions'
  
  task :load do
    FileList["models/**/*.rb"].each do |model|
      load model
    end
  end
  
  desc 'Perform automigration - will wipe out db'
  task :automigrate do
    Rake::Task["db:load"].invoke
    ::DataMapper.auto_migrate!
  end

  desc 'Perform non destructive automigration'
  task :autoupgrade do
    Rake::Task["db:load"].invoke
    ::DataMapper.auto_upgrade!
  end
  
  desc 'Seeds with init data'
  task :seed do
     load File.new("db/seeds.rb")
  end
  
  desc 'Seeds with init and test data'
  task :testseed do
    load File.new("db/seeds_test.rb")
  end
end

task :test do
  load File.new("db/tests.rb")
end
