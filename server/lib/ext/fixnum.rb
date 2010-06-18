class Fixnum
	def spaced_hex(length=8)
		self.to_s(16).spaced_hex(length)
	end
end
