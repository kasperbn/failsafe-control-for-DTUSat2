class Fixnum
	def spaced_hex(bytes=4)
		"0x#{self.to_s(16)}".spaced_hex(bytes)
	end
end
