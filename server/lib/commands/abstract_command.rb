require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/constants'
require ROOT_DIR+'/lib/string_extensions'

class AbstractCommand
	include ResponseHelpers
	include Constants

	attr_accessor :validation_errors

  def execute(id, caller)
    caller.send response(id, STATUS_OK)
  end

	def validate
	end

  def valid?
  	@validation_errors = []
		validate
		@validation_errors.empty?
  end
end
