class Promotion
	include DataMapper::Resource
	property :id,		Serial, :key=>true
	property :thing,	Text, :required => true
	property :claimed_by_person_id,	Integer

	property :modified_at,	DateTime
	property :created_at,	DateTime
end

