class Session < ActiveRecord::Base
	attr_accessor :username, :password
	attr_protected :token

	belongs_to :user

	validate :is_authentic?

	def is_authentic?
		self.user = User.authenticate(@username, @password)
		errors.add :email, 'Tjek venligst brugernavn og adgangskode' if self.user.nil?
	end

end
