require 'singleton'
require File.dirname(__FILE__)+"/fs_logger"
require File.dirname(__FILE__)+"/translate"
require File.dirname(__FILE__)+"/client_session"

class Server
  include Singleton
  include Loggable

	VERSION = '1.0'
	TOKEN_TIMEOUT = 30

	LISTENING_ON = "Listening on $0"
	TOKEN_HAS_BEEN_RESET = "Token has been reset after $0 seconds of inactivity"

  attr_reader :token

  def start(host, port)
    @server = TCPServer.open(host, port)
    @port = @server.addr[1]
    @addrs = @server.addr[2..-1].uniq
    @token = nil

    log LISTENING_ON.translate("#{@addrs.collect{|a|"#{a}:#{@port}"}.join(' ')}")
    listen
  end

	def token=(token)
		@token = token
		if @token == nil
			stop_token_timer
		else
			start_token_timer
		end
	end

	def reset_token_timer
		@token_timer = TOKEN_TIMEOUT
	end

	def stop_token_timer
		@token_timer_thread.kill
	end

  def locked?
    !token.nil?
  end

  private
	def start_token_timer
		reset_token_timer
		@token_timer_thread = Thread.new do
			loop do
				sleep(1)
				@token_timer -= 1
				if @token_timer < 1
					log TOKEN_HAS_BEEN_RESET.translate(TOKEN_TIMEOUT)
					self.token = nil
				end
			end
		end
	end

  def listen
    loop do
      Thread.start(@server.accept) do |tcpsocket|
        port = tcpsocket.peeraddr[1]
        name = tcpsocket.peeraddr[2]
        ClientSession.new(tcpsocket, "#{name}:#{port}")
      end
    end
  end
end
