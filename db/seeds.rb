#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
f=File.read("/home/ec2-user/educorez1/db/subway.json").split(",\n")
f.each do |s|
	puts hash = eval(s.strip)
	Subway.create(name: hash[:name], line: hash[:line], area: hash[:area], address: hash[:address], location_x: hash[:Lng], location_y: hash[:Lat])
end

a=File.read("/home/ec2-user/educorez1/db/college_db.json").split("\n")
a.each do |s|
	puts hash = eval(s.strip)
	College.create(name: hash["name"], area: hash["area"], address: hash["address"], location_x: hash["Lng"].to_f, location_y: hash["Lat"].to_f)
end
