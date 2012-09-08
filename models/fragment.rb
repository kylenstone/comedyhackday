class Fragment
	include DataMapper::Resource
	property :id,		Serial, :key=>true
	property :type,		String, :required => true, :default => 'program'
	property :level,	Integer, :required => true, :default => 0
	property :fragment,	Text, :required => true
	property :pullurl,	Text	

	property :modified_at,	DateTime
	property :created_at,	DateTime
end

