root = ::File.dirname(__FILE__)
require ::File.join(root, "app")
set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : 'mirostest')

run LEDIT.new
