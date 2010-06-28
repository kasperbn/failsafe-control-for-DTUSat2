require 'fileutils'
class FSLogger

	attr_accessor :filename, :logformat, :timeformat

	def initialize(filename, logformat = "[%time] %message", timeformat = "%d/%m/%Y %H:%M:%S")
		@filename = filename
		@logformat = logformat
		@timeformat = timeformat
	end

	def log(s)
		time = Time.now.strftime(@timeformat)
		msg = @logformat.gsub("%time",time).gsub("%message",s)

		if @filename == STDOUT
			$stdout.puts(msg)
		else
			FileUtils.touch(@filename) unless File.exists?(@filename)
			File.open(@filename, 'a') do |f|
				f.puts(msg)
			end
		end
	end
end

module Loggable
  def log(s) $LOG.log(s); end
end
