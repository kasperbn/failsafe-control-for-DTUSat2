require 'pty'

PTY.spawn("scripts/maintenance/reset", `fsclient -d lock`.gsub("\n","")) do |sr, sw, spid|
	begin
		loop do
			puts sr.readline
		end
	rescue => e
		puts "Error: #{e}"
	end
end
