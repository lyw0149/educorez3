require "json"
require "net/http"
require "uri"
require "nokogiri"
require 'active_support/all'
require 'roo'
=begin
xlsx = Roo::Excelx.new("./college_list.xlsx")
File.open("college.json","w") do |f|
	f.write(colleges=xlsx.sheet("2015학교리스트").to_json)
end
=end
File.open("subway_db.rb") do |db|
	db.read.each_line.with_index do |l,index|
		File.open("subway.json","a") do |f|
		l=l[1..-4]
		subway_tmp0=l.split(", ")
		area=subway_tmp0[1][1..-2]
		line=subway_tmp0[2][1..-2]
		name=subway_tmp0[3][1..-2].sub(/\(.*\)/,"")+"역"
		ascii_name = ""
		ascii_line = ""
		ascii_area = ""
		area.each_byte do |c|
			ascii_area += "%"+ c.to_s(16)
		end
		name.each_byte do |c|
			ascii_name += "%"+ c.to_s(16)
		end
		line.each_byte do |c|
			ascii_line += "%"+ c.to_s(16)
		end
			url = "http://openapi.naver.com/search?key=03b04ac7b6b264c04c8ef61199fc2947&query="+ascii_line+" "+ascii_name+"&target=local&start=1&display=1"
		resp = Net::HTTP.get_response(URI.parse(url))
		result = resp.body
		result = Hash.from_xml(result)
		address = result["rss"]["channel"]["item"]["address"]
		location_x = result["rss"]["channel"]["item"]["mapx"]
		location_y = result["rss"]["channel"]["item"]["mapy"]
		url = "https://apis.daum.net/local/geo/transcoord?apikey=59f7115d15a92ba1765f16b7a1a544d6&&fromCoord=KTM&y=" + location_y + "&x=" + location_x + "&toCoord=WGS84&output=json"
		resp = Net::HTTP.get_response(URI.parse(url))
		result = resp.body
		result = JSON.parse(result)
		location_x = result["x"]
		location_y = result["y"]
		subway_tmp = {}
		subway_tmp["name"]=name
		subway_tmp["line"]=line
		subway_tmp["area"]=area
		subway_tmp["address"]=address
		subway_tmp["Lat"]=location_y
		subway_tmp["Lng"]=location_x
		f.write(subway_tmp.to_json)
		f.write(",\n")
		#subway.push(subway_tmp)
		puts subway_tmp["name"]
		end
	end
end
