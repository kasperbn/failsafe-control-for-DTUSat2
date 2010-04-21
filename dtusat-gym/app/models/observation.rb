class Observation < ActiveRecord::Base

	belongs_to :user

	validate :position_format
	def position_format
		errors.add :position, 'Formatet for position er "d d d A" hvor d er et decimaltal (med punktum som decimalseparator) og A er et bogstav.' if (self.position =~ /^(\d+\.\d+\s){3}[a-zA-Z]$/).nil?
	end

end
