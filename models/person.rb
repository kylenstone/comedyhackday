class Person
	include DataMapper::Resource
	property :id,		Serial, :key=>true
	property :firstname,	String, :required => true
	property :lastname, 	String, :required => true
	property :email,	String, :required => true
	property :phone,	String, :required => true
	
	property :modified_at,	DateTime
	property :created_at,	DateTime
end

