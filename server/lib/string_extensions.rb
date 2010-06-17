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

	def translate(*subs)
		s = self.clone
		subs.each_index do |i|
			s.gsub!("$#{i}",subs[i].to_s)
		end
		s
	end
end
