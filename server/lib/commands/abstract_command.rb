require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/messages_and_statuses'

class AbstractCommand
	include ResponseHelpers
	include MessagesAndStatuses

  def execute(caller, id)
    response(:status => STATUS_OK, :data => "Execute #{self.class.to_s} command")
  end
end
