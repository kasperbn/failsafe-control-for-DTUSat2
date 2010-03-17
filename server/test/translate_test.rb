require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/translate"

class StringTest < Test::Unit::TestCase

	def test_should_translate
		s = 'I ride a $0 to $1'
		assert_equal 'I ride a bike to the mall', s.translate('bike', 'the mall')
	end

	def test_should_translate_integers
		s = 'I have $0 coins'
		assert_equal 'I have 20 coins', s.translate(20)
	end

end
