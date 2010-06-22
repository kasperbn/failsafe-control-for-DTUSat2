require File.dirname(__FILE__) + "/../test_helpers"

require ROOT_DIR + "/lib/command_parser"

class CommandParserTest < Test::Unit::TestCase

  def test_should_parse_lock_without_token
  	request = {:id => "1", :data => "lock"}.to_json
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "lock", token
    assert_equal Commands::Lock, command.class
  end

  def test_should_parse_with_token
  	request = {:id => "1", :data => "0123456789abcdef reset"}.to_json
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal Commands::Reset, command.class
  end

  def test_should_not_parse_unknown_commands
  	request = {:id => "1", :data => "0123456789abcdef unknown_command"}.to_json
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal Commands::Unknown, command.class
  end

  def test_should_not_parse_with_wrong_number_of_arguments
  	request = {:id => "1", :data => "0123456789abcdef reset timeout invalid_argument"}.to_json
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal Commands::WrongNumberOfArguments, command.class
  end

end
