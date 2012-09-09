class Teaser
	include DataMapper::Resource
	property :id,		Serial, :key=>true
	property :type,		String, :required => true, :default => 'joke'
	property :question,	Text, :required => true
	property :response,	Text, :required => true

	property :modified_at,	DateTime
	property :created_at,	DateTime
end

