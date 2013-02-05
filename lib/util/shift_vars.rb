
offset = ARGV[1].to_i

File.foreach(ARGV[0]) { |line| 
	puts line.gsub(/([^A-Za-z0-9\_]?)y\(([0-9]+)\)/) { 
		|match| $1 + "y(#{$2.to_i + offset})"
	}
}
