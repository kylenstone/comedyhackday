class Person
	include DataMapper::Resource
	property :id,		Serial, :key=>true
	property :phone,	String, :required => true
	property :last_pinged,	DateTime, :required => false
	
	property :modified_at,	DateTime
	property :created_at,	DateTime
end

