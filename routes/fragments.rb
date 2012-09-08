class LEDIT < Sinatra::Application

	before do
		content_type :json
	end

	get '/fragments/?' do
		fragments = Fragment.all()
		@Response.result = fragments.as_json(:exclude => @allExclude)
		@Response.to_response
	end

	get '/fragment/:id/?' do
		fragment = Fragment.get(params[:id])
		if(fragment.nil?)
			@Response.add_error :type => "Invalid_id", :message => "No fragment found with id = #{params[:id]}"
		else
			@Response.result = fragment.as_json(:exclude => @allExclude)
		end
		@Response.to_response
	end

	put '/fragment/:id/?' do
		puts params
		["splat","captures"].each {|k| params.delete(k)}
		put_or_post(params)
	end

	post '/fragments/?' do
		[:id].each { |k| params.delete(k) }
		put_or_post(params)
	end

	def put_or_post(params)
		puts params
		query_params = {}
		
		if(!params.include?("fragment")) 
			@Response.add_error :type => "Required_field", :message => "the fragment field is required!"
		end

		params.each { |key, value|
      
     			# check if param is permitted
			if (Fragment.properties.named?(key))
        
			        # Validate integer values
		        	if (Fragment.properties[key].class == DataMapper::Property::Integer)
			          begin
        			    Integer(value)
			          rescue ArgumentError => e
        			    @Response.add_error :type => "Invalid_Type", :message => "Value of '#{key}' must be an integer type"
	        		  end
	        		end
        
        			query_params[key.to_sym] = value
		 	else
				@Response.add_error :type => "Invalid_Parameter", :message => "Parameter '#{key}' is invalid"
			end
		}		
		fragment = nil

		if(!@Response.is_error?)
    			puts query_params
			# check if we have an id to update (PUT request)
			if(!query_params[:id].nil?)
				fragment = Fragment.get(query_params[:id])
            			if(fragment.nil?)
                			@Response.add_error :type => "Not_Found", :message => "No fragment found with id = #{query_params[:id]}"
            			else
   			            Fragment.transaction do
			                   if(!fragment.destroy() || !(fragment = Fragment.new(query_params)).save)
                			        @Response.add_error :type => "Transaction_Failed", :message=>"Transaction for fragment id #{query_params[:id]} failed" 
		        	           end
	               		    end
	            		end
		        else #create a new one and save it
            			fragment = Fragment.new(query_params)
			        if(!fragment.save)
			                @Response.add_error :type => "Save_Failed", :message => "Fragment failed to save #{fragment.errors.inspect}"
		        end
	            status 201
        	end
        	# if nothing has gone wrong, return the object
	        if(!@Response.is_error?)
	            @Response.result = fragment.as_json(:exclude => @allExclude)
        	end
	    else
            if(response.status == 200)
            	status 400
	    end
    end

    @Response.to_response
	
	end

end
