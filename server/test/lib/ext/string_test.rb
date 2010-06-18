require 'test/unit'
require File.dirname(__FILE__) + "/../../../lib/ext/string"

class StringTest < Test::Unit::TestCase

  def test_is_addressable?
    assert_equal true, "0x01234567".addressable?
    assert_equal true, "0x89ABCDEF".addressable?
    assert_equal true, "0x89abcdef".addressable?
    assert_equal true, "0xff".addressable?

    assert_equal false, "0x01234556789abcdef".addressable?
    assert_equal true,  "0x01234556789abcdef".addressable?(16)

    assert_equal false, "0x100000000".addressable?
    assert_equal false, "-0x1".addressable?
    assert_equal false, "0xfg".addressable?
    assert_equal false, "0x0.2".addressable?
    assert_equal false, "0x0,2".addressable?

    assert_equal true, "0".addressable?
    assert_equal true, "4294967295".addressable?

    assert_equal false, "4294967296".addressable?
    assert_equal false, "-1".addressable?
    assert_equal false, "a".addressable?
    assert_equal false, "0.1".addressable?
    assert_equal false, "0,1".addressable?

    assert_equal false, "address".addressable?
  end

	def test_spaced_hex
		assert_equal "00 00 00 00", "0x00000000".spaced_hex
		assert_equal "00 00 00 00", "0x0".spaced_hex
		assert_equal "00 00 00 ff", "0xff".spaced_hex
		assert_equal "ff 00 00 00", "0xff000000".spaced_hex
		assert_equal "ff ee dd cc", "0xffeeddcc".spaced_hex
		assert_equal "ff ff ff ff", "0xffffffff".spaced_hex

		assert_raise NotAddressableError do "0x123456789".spaced_hex end
		assert_raise NotAddressableError do "-0x1".spaced_hex end

		assert_equal "00 00 00 00", "0".spaced_hex
		assert_equal "00 00 00 ff", "255".spaced_hex
		assert_equal "00 00 02 00", "512".spaced_hex
		assert_equal "00 00 04 00", "1024".spaced_hex
		assert_equal "00 00 08 00", "2048".spaced_hex
		assert_equal "ff ff ff ff", "4294967295".spaced_hex

		assert_raise NotAddressableError do "4294967296".spaced_hex end
		assert_raise NotAddressableError do "-1".spaced_hex end

		assert_equal "00 00", "0".spaced_hex(4)
		assert_equal "00 ff", "255".spaced_hex(4)
		assert_equal "00 00 00 00 00 00 00 00", "0x0".spaced_hex(16)
		assert_equal "ff ff ff ff ff ff ff ff", "0xffffffffffffffff".spaced_hex(16)

		assert_raise NotDividableByTwoError do assert_equal "00", "0".spaced_hex(3) end
	end

end
