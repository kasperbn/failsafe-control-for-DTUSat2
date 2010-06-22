require File.dirname(__FILE__) + "/../test_helpers"

require ROOT_DIR + "/lib/processing_queue"

class ProcessingQueueMocker
	include ProcessingQueue

	def initialize
		setup_processing_queue
	end

	def ready?
		true
	end

	def process(request, &callback)
#		puts "About to process: #{request}"
#		sleep(1)
		puts "Processed: #{request}"
	end
end

class CommandParserTest < Test::Unit::TestCase

  def test_should_process_two_commands

		@p = ProcessingQueueMocker.new

		threads = []

		25.times {|n|
			threads << Thread.new {
				@p.enqueue("Operation #{n}")
			}
		}

		25.times {|n|
			threads << Thread.new {
				@p.enqueue("Operation #{n}")
			}
		}

		threads.each do|t| t.join end

  end

end
