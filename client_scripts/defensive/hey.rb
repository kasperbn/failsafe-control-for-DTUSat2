#!/usr/bin/ruby

require 'pty'
require 'expect'

$token = ARGV[0]

def fsclient(*args)
	begin
		PTY.spawn('fsclient', $token, *args) do |r, w, pid|
			loop {
				out = r.expect(%r/^.+\n$/io)
				puts out unless out.nil?
			}
		end
	rescue PTY::ChildExited => e
	end
end

fsclient('run_script', 'maintenance/reset', '')
fsclient('execute', '0x123123')
fsclient('sleep', '2')
fsclient('reset')
