class User < ActiveRecord::Base

	validates_presence_of :username
	validates_uniqueness_of :username
	validates_format_of :position, :with => Observation::POSITION_FORMAT, :message => Observation::POSITION_MESSAGE

	has_many :observations, :dependent => :destroy
	has_many :sessions, :dependent => :destroy

	def latest_session
		self.sessions.find(:first, :order => 'created_at DESC')
	end

	# Returns authenticated user or nil
  def self.authenticate(username, password)
    find(:first, :conditions => ["username = ? AND password = ?", username, password]) rescue nil
  end

end
