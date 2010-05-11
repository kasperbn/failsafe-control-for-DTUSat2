require ROOT_DIR+'/lib/response_helpers'

class AbstractCommand
	include ResponseHelpers

  def execute
    ok("Execute #{self.class.to_s} command")
  end
end
