require 'test/unit'
require File.dirname(__FILE__) + "/../lib/command_parser"
require File.dirname(__FILE__) + "/../lib/translate"

class CommandParserTest < Test::Unit::TestCase

  def test_should_not_parse_unknown_commands
    assert_equal 	CommandParser::UNKNOWN_COMMAND.translate('unknown_command'),
    							CommandParser.parse('unknown_command')[1]
  end

  def test_should_parse_reset_with_zero_arguments
    assert_instance_of 	Commands::Reset,
    										CommandParser.parse('token123123 reset')[1]
    assert_equal 	CommandParser::WRONG_ARGUMENTS.translate('reset'),
    							CommandParser.parse('token123123 reset arg1')[1]
  end

  def test_should_parse_execute_with_one_argument
    assert_instance_of 	Commands::Execute,
    										CommandParser.parse('token123123 execute arg1')[1]
    assert_equal 	CommandParser::WRONG_ARGUMENTS.translate('execute'),
    							CommandParser.parse('token_123123 execute')[1]
  end

  def test_should_parse_copy_to_flash_with_one_argument
    assert_instance_of 	Commands::CopyToFlash,
    										CommandParser.parse('token123123 copy_to_flash arg1')[1]
    assert_equal 	CommandParser::WRONG_ARGUMENTS.translate('copy_to_flash'),
    							CommandParser.parse('token_123123 copy_to_flash')[1]
  end

end
