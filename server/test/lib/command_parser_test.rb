require File.dirname(__FILE__) + "/../test_helpers"

require ROOT_DIR + "/lib/command_parser"

class CommandParserTest < Test::Unit::TestCase

  def test_should_parse_lock_without_token
  	request = '{"id":"1", "data":"lock"}'
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal nil, token
    assert_equal Commands::Lock, command.class
  end

  def test_should_parse_with_token
  	request = '{"id":"1", "token":"0123456789abcdef", "data":"reset"}'
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal Commands::Reset, command.class
  end

  def test_should_not_parse_unknown_commands
  	request = '{"id":"1", "token":"0123456789abcdef", "data":"blast_venus"}'
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal Commands::Unknown, command.class
  end

  def test_should_not_parse_with_wrong_number_of_arguments
  	request = '{"id":"1", "token":"0123456789abcdef", "data":"reset invalid_argument"}'
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal Commands::WrongNumberOfArguments, command.class
  end

  def test_should_extract_options
  	request = '{"id":"1", "token":"0123456789abcdef", "data":"reset --timeout=20 --no-response"}'
  	id, token, command = CommandParser.new.parse(request)

    assert_equal "1", id
    assert_equal "0123456789abcdef", token
    assert_equal ({"timeout"=>"20", "no-response"=>true}, command.options)
  end

end
