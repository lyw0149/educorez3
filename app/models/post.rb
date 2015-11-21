class Post < ActiveRecord::Base
	is_impressionable
	resourcify
	include Authority::Abilities
  belongs_to :user
end
