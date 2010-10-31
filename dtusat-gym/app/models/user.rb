class User < ActiveRecord::Base

	validates_presence_of :username
	validates_uniqueness_of :username
	validate :position_format

	has_many :observations, :dependent => :destroy
	has_many :sessions, :dependent => :destroy

	def position_format
		errors.add :position, 'Formatet for position er "d d d A" hvor d er et decimaltal (med punktum som decimalseparator) og A er et bogstav.' if (self.position =~ /^(\d+\.\d+\s){3}[a-zA-Z]$/).nil?
	end

	def latest_session
		self.sessions.find(:first, :order => 'created_at DESC')
	end

	# Returns authenticated user or nil
  def self.authenticate(username, password)
    find(:first, :conditions => ["username = ? AND password = ?", username, password]) rescue nil
  end

end
