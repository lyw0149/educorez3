require 'json'
require 'net/http'
require 'uri'
require 'active_support/all'
f=File.read("/home/ec2-user/educorez1/db/college.json")
a = JSON.parse(f)
a.each_with_index do |l,index|
	bit = 0
	File.open("new_college_db2.json","a") do |file|
		s=l
		hash= {}
		ascii_name=""
		s[4].each_byte do |c|
			ascii_name += "%" + c.to_s(16)
		end
		class_array = s[5].split('/')
		len=class_array.length
		if s[4] == "경인교육대학교"
			bit = 1
		end
		i=1
		if bit == 1
			url = "https://apis.daum.net/local/v1/search/keyword.xml?apikey=59f7115d15a92ba1765f16b7a1a544d6&query="+ascii_name
			resp = Net::HTTP.get_response(URI.parse(url))
			result = resp.body
			result = Hash.from_xml(result)
			if  result["channel"]["info"]["totalCount"].to_i > 1
				name = result["channel"]["item"][i]["title"]
				address = result["channel"]["item"][i]["address"]
				road_address =result["channel"]["item"][i]["newAddress"]
				location_x = result["channel"]["item"][i]["longitude"]
				location_y = result["channel"]["item"][i]["latitude"]
			elsif
				name = result["channel"]["item"]["title"]
				address = result["channel"]["item"]["address"]
				road_address =result["channel"]["item"]["newAddress"]
				location_x = result["channel"]["item"]["longitude"]
				location_y = result["channel"]["item"]["latitude"]
			end
			#url = "https://apis.daum.net/local/geo/transcoord?apikey=59f7115d15a92ba1765f16b7a1a544d6&&fromCoord=KTM&y=" + location_y + "&x=" + location_x + "&toCoord=WGS84&output=json"
			#resp = Net::HTTP.get_response(URI.parse(url))
			#result = resp.body
			#result = JSON.parse(result)
			#location_x = result["x"]
			#location_y = result["y"]
			hash["name"]=name
			hash["area"]=s[7]
			hash["address"]=address
			hash["road_address"]=road_address
			hash["Lat"]=location_y
			hash["Lng"]=location_x
			puts "#{hash["name"]} #{hash["address"]} #{hash["Lat"]} #{hash["Lng"]}"
			file.write(hash)
			file.write("\n")
		end
	end
end
