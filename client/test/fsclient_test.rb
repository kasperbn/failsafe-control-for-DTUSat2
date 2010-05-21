ROOT = File.dirname(__FILE__) + '/..'
HOST = '0.0.0.0'
PORT = 3000

require 'test/unit'
require 'pty'

class FSClientTest < Test::Unit::TestCase

	def test_interactive_mode
		PTY.spawn("#{ROOT}/fsclient -ia") do |r,w,pid|
			@r, @w, @pid = r,w,pid

			assert_match /FSClient - Interactive/, @r.gets
			assert_match /Token remembered/, @r.gets

			send 'reset'
			assert_match /Commands::Reset/, @r.gets

			send 'execute 123123'
			assert_match /Commands::Execute/, @r.gets

			send 'unlock'
			assert_match /Server has been unlocked/, @r.gets

			send 'lock'
			assert_match /\w+/, @r.gets

			send 'exit'
		end
	end

	def send(command)
		2.times {@r.getc.chr} # Flush cursor ('> ')
		@w.puts command
		@r.gets # First gets is the command it self
	end
end
