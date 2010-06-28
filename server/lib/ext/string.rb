class NotAddressableError < StandardError; end
class NotANumberError < StandardError; end

class String
  def camelize
    self.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
  end

	def positive?
		self.positive_integer? || self.positive_hex?
	end

	def positive_integer?
		self.match(/^\d+$/) != nil
	end

	def positive_hex?
		self.match(/^(0x(\d|[a-fA-F])+)$/) != nil
	end

	def addressable?(bytes=4)
		addressable_int?(bytes) || addressable_hex?(bytes)
	end

	def addressable_int?(bytes=4)
		self.positive_integer? and self.to_i.to_s(16).size <= bytes*2
	end

	def addressable_hex?(bytes=4)
		self.positive_hex? and self.hex.to_s(16).size <= bytes*2
	end

	def int_or_hex(bytes=4)
		if self.addressable_hex?(bytes)
			self.hex
		elsif self.addressable_int?(bytes)
			self.to_i
		else
			raise NotANumberError
		end
	end

	def byte_length
		val = if self.positive_hex?
			self.hex
		elsif self.positive_integer?
			self.to_i
		else
			raise NotANumberError
		end
		l = val.to_s(16).size
		l += 1 unless l%2==0
		l/2
	end

	def spaced_hex(bytes=4)
		length = bytes*2
		raise NotAddressableError unless self.addressable?(bytes)

		# Prepend zeroes
		s = int_or_hex(bytes).to_s(16)
		s = "0"*(length-s.size)+s

		# Divide after each two
		r = []
		bytes.times {|n| r << s[n*2..n*2+1]}
		r.join(" ")
	end

end
