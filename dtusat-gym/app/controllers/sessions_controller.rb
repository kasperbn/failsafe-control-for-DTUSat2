class SessionsController < ApplicationController

	layout 'login'

	# Login-GUI
	def new
		if logged_in?
			redirect_to params[:redirect_to] || current_user
		end
		@session = Session.new

  end

	# Authenticate
	def create
		@session = Session.new(params[:session])
		if @session.save
			session[:id] = @session.id
			redirect_to observations_path
		else
			render :new
		end
	end

	# Logout
	def destroy
		current_session.deleted_at = Time.now rescue nil #Already destroyed
    reset_session
    redirect_to new_session_path
	end

end
