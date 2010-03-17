class String
	def translate(*subs)
		s = self
		subs.each_index do |i|
			s.gsub!("$#{i}",subs[i].to_s)
		end
		s
	end
end
