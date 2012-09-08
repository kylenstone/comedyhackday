require 'sinatra'
require 'json'
require 'active_support/core_ext/date_time/calculations'
class LEDIT < Sinatra::Application
  # set defaults here
  configure :production do
  
  end

  configure :development do

  end

  get '/' do
	redirect '/index.html'
  end

  set :public_folder, 'public'
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
