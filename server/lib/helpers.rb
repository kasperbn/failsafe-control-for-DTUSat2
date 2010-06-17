def puts_errors
	begin
		yield
	rescue => e
		puts "Error: #{e}"
	end
end
