f=File.read("subway.json").split(",\n").map! {|f| eval(f.strip)}
puts f[0].class
