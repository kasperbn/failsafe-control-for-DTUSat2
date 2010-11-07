class Observation < ActiveRecord::Base

  # Example: "55 46 37.7 N 12 17 21.4 E"
  POSITION_FORMAT = /^((\d+\s){2}(\d+\.\d+\s)[a-zA-Z])+\s+((\d+\s){2}(\d+\.\d+\s)[a-zA-Z])$/

	belongs_to :user

	validate :position_format
	def position_format
		errors.add :position, 'Formatet for position er "h h d A h h d A" hvor h er et heltal, d er et decimaltal (med punktum som decimalseparator) og A er et bogstav. Eksempel: "55 46 37.7 N 12 17 21.4 E"' if (self.position =~ POSITION_FORMAT).nil?
	end

end