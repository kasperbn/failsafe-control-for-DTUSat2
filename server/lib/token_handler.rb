require 'singleton'
require ROOT_DIR+"/lib/fs_logger"

class TokenHandler
  include Singleton
  include Loggable

	TOKEN_HAS_BEEN_RESET = "Token has been reset after $0 seconds of inactivity"
	TOKEN_TIMEOUT = 30

	attr_reader :token

	def initialize
		@token = nil
	end

	def token=(token)
		@token = token
		if free?
			stop_timer
		else
			start_timer
		end
	end

	def free?
		@token.nil?
	end

	def taken?
		!free?
	end

	def stop_timer
		@timer_thread.kill
	end

	def reset_timer
		@timer = TOKEN_TIMEOUT
	end

  private
	def start_timer
		reset_timer
		@timer_thread = Thread.new do
			loop do
				sleep(1)
				@timer -= 1
				if @timer < 1
					log TOKEN_HAS_BEEN_RESET.translate(TOKEN_TIMEOUT)
					self.token = nil
				end
			end
		end
	end

end
