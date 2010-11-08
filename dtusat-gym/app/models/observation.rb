class Observation < ActiveRecord::Base

  # Example: "55 46 37.7 N 12 17 21.4 E"
  POSITION_FORMAT = /^((\d+\s){2}(\d+\.\d+\s)[a-zA-Z])+\s+((\d+\s){2}(\d+\.\d+\s)[a-zA-Z])$/
  POSITION_MESSAGE = 'Formatet for position er "h h d A h h d A" hvor h er et heltal, d er et decimaltal (med punktum som decimalseparator) og A er et bogstav. Eksempel: "55 46 37.7 N 12 17 21.4 E"'

	belongs_to :user

  validates_presence_of :user_id, :message => 'Vælg venligst en bruger'
  validates_presence_of :elevation, :message => 'Indtast venligst en elevation'
  validates_presence_of :azimuth, :message => 'Indtast venligst en azimuth'
  validates_presence_of :position, :message => 'Indtast venligst en position'
	validates_format_of :position, :with => Observation::POSITION_FORMAT, :message => Observation::POSITION_MESSAGE  

end