module MessagesAndStatuses

	# Server
	MESSAGE_MUST_LOCK = "You must lock the server before executing commands"
	MESSAGE_ALREADY_LOCKED = "You have already locked with token: $0"
	MESSAGE_IS_LOCKED = "Server is locked"
	MESSAGE_SERVER_UNLOCKED = "Server has been unlocked"

	STATUS_OK = 0
	STATUS_ERROR = 1
	STATUS_IS_LOCKED = 2
	STATUS_MUST_LOCK = 3
	STATUS_ALREADY_LOCKED = 4

	# Command Parser
	MESSAGE_WRONG_ARGUMENTS = "Wrong number of arguments for command: $0"
	MESSAGE_UNKNOWN_COMMAND = "Unknown command: $0"
	MESSAGE_INVALID_FORMAT = "Invalid format: $0"

	STATUS_WRONG_ARGUMENTS = 5
	STATUS_UNKNOWN_COMMAND = 6
	STATUS_INVALID_FORMAT = 7
end
