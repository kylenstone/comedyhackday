class Person
	include DataMapper::Resource
	property :id,		Serial, :key=>true
	property :phone,	String, :required => true
	property :teaser_id	Number, :required => true
	
	property :modified_at,	DateTime
	property :created_at,	DateTime
end

