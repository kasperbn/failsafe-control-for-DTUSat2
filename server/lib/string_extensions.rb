class String
  def camelize
    self.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
  end

	# Returns "ff 00 00 00" for "ff000000"
	def spaced_hex
		l = self.size
		i = 0
		r = ""
		while(i+1 < l)
			r += " #{self[i..i+1]}"
			i += 2
		end
		r[1..-1] # Remove first space
	end

	def int_or_hex
		if self[0..1] == "0x"
			self.hex
		else
			self.to_i
		end
	end
end
