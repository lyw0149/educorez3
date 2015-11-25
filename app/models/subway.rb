class Subway < ActiveRecord::Base
	validates_uniqueness_of :name, :scope => :area
end
