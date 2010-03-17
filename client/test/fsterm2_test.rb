ROOT = File.dirname(__FILE__) + '/..'
HOST = '0.0.0.0'
PORT = 3000

require 'test/unit'
require 'pty'
require "#{ROOT}/lib/fsterm2"

class FSTerm2Test < Test::Unit::TestCase

	def test_interactive_mode
		PTY.spawn("#{ROOT}/fsterm2 -i -a") do |r,w,pid|
			@r, @w, @pid = r,w,pid

			assert_match /FSTerm2 Version 1.0/, @r.gets
			assert_match /Kasper /, @r.gets
			assert_match /Request:  'lock'/, @r.gets
			assert_match /Response: '\w+'/, @r.gets
			assert_match /Token remembered /, @r.gets

			send 'reset'

			assert_match /Request:  '\w+ reset'/, @r.gets
			assert_match /Commands::Reset/, @r.gets

			send 'execute 123123'

			assert_match /Request:  '\w+ execute 123123'/, @r.gets
			assert_match /Commands::Execute/, @r.gets

			send 'unlock'

			assert_match /Request:  '\w+ unlock'/, @r.gets
			assert_match /Response: 'Server has been unlocked'/, @r.gets

			send 'lock'

			assert_match /Request:  'lock'/, @r.gets
			assert_match /Response: '\w+'/, @r.gets

			send 'exit'

			assert_match /exit/, @r.gets
			assert_match /Request:  '\w+ unlock'/, @r.gets
			assert_match /Response: 'Server has been unlocked'/, @r.gets
		end
	end

	def send(command)
		2.times {@r.getc.chr} # Flush cursor ('> ')
		@w.puts command
		@r.gets # First gets is the command it self
	end
end
