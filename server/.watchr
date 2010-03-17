def run_tests(cmd)
	result = cmd
	failure = (result =~ /0 failures, 0 errors$/).nil?
	last_line = result.split("\n")[-1]

	if failure
		system "notify-send --expire-time=500 -i gtk-no 'Tests failed' \"#{last_line}\""
	else
		system "notify-send --expire-time=500 -i gtk-yes 'Tests passed' \"#{last_line}\""
	end
	puts result
end

watch('test/(.*)\_test.rb') do |md|
	run_tests(`ruby #{md[0]}`)
end

watch('lib/(.*)\.rb') do |md|
	run_tests `ruby test/#{md[1]}_test.rb`
end
