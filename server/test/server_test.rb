ROOT = File.dirname(__FILE__) + '/..'
HOST = '0.0.0.0'
PORT = 3000

require 'test/unit'
require 'pty'
require "#{ROOT}/lib/server"
require "#{ROOT}/lib/translate"

class ServerTest < Test::Unit::TestCase

	def test_client_session
		# Fire up server and wait for startup
		sr, sw, spid = PTY.spawn("#{ROOT}/fsserver --host=#{HOST} --port=#{PORT}")
		assert_match Server::LISTENING_ON.translate("#{HOST}:#{PORT}"), sr.gets

		# connect client via telnet
		cr, cw, cpid = PTY.spawn("telnet #{HOST} #{PORT}")
		assert_match /localhost:[\d]* logged on/, sr.gets

		# Try to send reset command without lock
		cw.puts "reset"
		assert_match /Request  \(localhost:[\d]*\): reset/, sr.gets
		assert_match /Response \(localhost:[\d]*\): #{ClientSession::MUST_LOCK_SERVER}/, sr.gets

    # Lock server and save token
		cr.readpartial(4096) # Empty buffer
		cw.puts 'lock'
		assert_match /Request  \(localhost:[\d]*\): lock/, sr.gets
		assert_match /Response \(localhost:[\d]*\): \w+/, sr.gets
		assert_match /lock/, cr.gets
		token = cr.gets.gsub("\r\n",'')
		assert_match /\w+/, token

		# Send reset command again
		cw.puts "#{token} reset"
		assert_match /Request  \(localhost:[\d]*\): #{token} reset/, sr.gets
		assert_match /Response \(localhost:[\d]*\): Execute Commands::Reset command/, sr.gets

		# Timout lock
		sleep(Server::TOKEN_TIMEOUT)
		assert_match /#{Server::TOKEN_HAS_BEEN_RESET.translate(Server::TOKEN_TIMEOUT)}/, sr.gets
	end

end
