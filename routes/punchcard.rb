class Punchcard < Sinatra::Application

	before do
		content_type :json
	end

	get '/person/?' do
		people = Person.all()
		@Response.result = people.as_json(:exclude => @allExclude)
		@Response.to_response
	end

	get '/person/:id/?' do
		person = Person.get(params[:id])
		if(person.nil?)
			@Response.add_error :type => "Invalid_id", :message => "No person found with id = #{params[:id]}"
		else
			@Response.result = people.as_json(:exclude => @allExclude)
		end
		@Response.to_response
	end

	get '/promotion/?' do
		promotions = Promotion.all()
		@Response.result = promotions.as_json(:exclude => @allExclude)
		@Response.to_response
	end

	get '/promotion/:id/?' do
		promotion = Promotion.get(params[:id])
		if(promotion.nil?)
			@Response.add_error :type => "Invalid_id", :message => "No promotion found with id = #{params[:id]}"
		else
			@Response.result = promotion.as_json(:exclude => @allExclude)
		end
		@Response.to_response
	end

	put '/person/:id/?' do
		puts params
		["splat","captures"].each {|k| params.delete(k)}
		put_or_post_person(params)
	end

	post '/person/?' do
		[:id].each { |k| params.delete(k) }
		put_or_post_person(params)
	end

	def put_or_post_person(params)
		puts params
		query_params = {}
		
		if(!params.include?("phone")) 
			@Response.add_error :type => "Required_field", :message => "the phone field is required!"
		end

		params.each { |key, value|
      
     			# check if param is permitted
			if (Person.properties.named?(key))
        
			        # Validate integer values
		        	if (Person.properties[key].class == DataMapper::Property::Integer)
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
		person = nil

		if(!@Response.is_error?)
    			puts query_params
			# check if we have an id to update (PUT request)
			if(!query_params[:id].nil?)
				person = Person.get(query_params[:id])
            			if(person.nil?)
                			@Response.add_error :type => "Not_Found", :message => "No person found with id = #{query_params[:id]}"
            			else
   			            Person.transaction do
			                   if(!person.destroy() || !(person = Person.new(query_params)).save)
                			        @Response.add_error :type => "Transaction_Failed", :message=>"Transaction for person id #{query_params[:id]} failed" 
		        	           end
	               		    end
	            		end
		        else #create a new one and save it
            			person = Person.new(query_params)
			        if(!person.save)
			                @Response.add_error :type => "Save_Failed", :message => "Person failed to save #{person.errors.inspect}"
		        	end
	            		 # twilio API call goes here
	           account_sid = 'ACbf2e2146d9ec277d50b05c961767e60b'
                   auth_token = 'bcbd44797e527e36a76eee10dd3eda22'

                   # set up a client to talk to the Twilio REST API
                   @client = Twilio::REST::Client.new(account_sid, auth_token)

                   @message = @client.account.sms.messages.create({:from => '+16032612118', :to => person.phone, :body => "Registration confirmed"})
                   puts @message
	            		 
				           status 201
        		end
        	# if nothing has gone wrong, return the object
	        if(!@Response.is_error?)
	            @Response.result = person.as_json(:exclude => @allExclude)
        	end
	    else
            if(response.status == 200)
            	status 400
	    end
    end

    @Response.to_response
	
	end

	put '/promotion/:id/?' do
		puts params
		["splat","captures"].each {|k| params.delete(k)}
		put_or_post_promotion(params)
	end

	post '/promotion/?' do
		[:id].each { |k| params.delete(k) }
		put_or_post_promotion(params)
	end

	def put_or_post_promotion(params)
		puts params
		query_params = {}
		
		if(!params.include?("thing")) 
			@Response.add_error :type => "Required_field", :message => "the thing field is required!"
		end

		params.each { |key, value|
      
     			# check if param is permitted
			if (Promotion.properties.named?(key))
        
			        # Validate integer values
		        	if (Promotion.properties[key].class == DataMapper::Property::Integer)
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

		promotion = nil


		if(!@Response.is_error?)
    			puts query_params
			# check if we have an id to update (PUT request)
			if(!query_params[:id].nil?)
				promotion = Promotion.get(query_params[:id])
            			if(fragment.nil?)
                			@Response.add_error :type => "Not_Found", :message => "No person found with id = #{query_params[:id]}"
            			else
   			            Promotion.transaction do
			                   if(!promotion.destroy() || !(promotion = Promotion.new(query_params)).save)
                			        @Response.add_error :type => "Transaction_Failed", :message=>"Transaction for promotion id #{query_params[:id]} failed" 
		        	           end
	               		    end
	            		end
		        else #create a new one and save it
            			promotion = Promotion.new(query_params)
			        if(!promotion.save)
			                @Response.add_error :type => "Save_Failed", :message => "Promotion failed to save #{promotion.errors.inspect}"
		        end
	            status 201
        	end
        	# if nothing has gone wrong, return the object
	        if(!@Response.is_error?)
		    #blast the users
		    		
		    account_sid = 'ACbf2e2146d9ec277d50b05c961767e60b'
        	    auth_token = 'bcbd44797e527e36a76eee10dd3eda22'

              	    # set up a client to talk to the Twilio REST API
                    @client = Twilio::REST::Client.new(account_sid, auth_token)

		    targets = 6
		    count = 0
		    until count == targets 
			#person = Person.first(:offset => rand(Person.count), :last_pinged <= Time.now.to_i - 24*60*60))
	                person = Person.first(:offset => rand(Person.count))
	                person.last_pinged = Time.now.to_i
			person.save
			@message = @client.account.sms.messages.create({:from => '+16032612118', :to => person.phone, :body => "Hurry your ass up!  You vs #{targets}: #{promotion.thing}"})
                        puts @message
			count+=1
		    end
	            @Response.result = promotion.as_json(:exclude => @allExclude)
        	end
	    else
            if(response.status == 200)
            	status 400
	    end
    end

    @Response.to_response
	
	end


end
