class Punchcard < Sinatra::Application

  before do
    content_type :json

    # Response object
    @Response = Response.new
    
    # Params added by :id to be ignored
    @removeSPI = ["splat", "captures", "id"]

    # Object exclude field
    @allExclude = [:created_at, :modified_at]
   
  end

end
require_relative 'punchcard'
