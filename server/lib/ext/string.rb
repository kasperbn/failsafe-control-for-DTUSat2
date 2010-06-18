class NotAddressableError < StandardError; end
class NotDividableByTwoError < StandardError; end

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

	def addressable?(length=8)
		addressable_int?(length) || addressable_hex?(length)
	end

	def addressable_int?(length=8)
		self.positive_integer? and self.to_i.to_s(16).size <= length
	end

	def addressable_hex?(length=8)
		self.positive_hex? and self.hex.to_s(16).size <= length
	end

	def int_or_hex(length=8)
		if self.addressable_hex?(length)
			self.hex
		else
			self.to_i
		end
	end

	def spaced_hex(length=8)
		raise NotDividableByTwoError unless length % 2 == 0
		raise NotAddressableError unless self.addressable?(length)

		# Prepend zeroes
		s = int_or_hex(length).to_s(16)
		s = "0"*(length-s.size)+s

		# Divide after each two
		r = []
		(length/2).times {|n| r << s[n*2..n*2+1]}
		r.join(" ")
	end

end
