class UsersController < ApplicationController

	before_filter :require_login
	before_filter :require_admin, :only => [:destroy, :create, :new, :index]
	before_filter :require_current_id_unless_admin

	def index
		@users = User.all :order => 'username'
	end

	def new
    pw = ""
    4.times { pw << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
		@user = User.new :password => pw
	end

	def create
		@user = User.new params[:user]
		if @user.save
			redirect_to users_path
		else
			flash[:error] = 'Brugeren kunne ikke gemmes'
			render :new
		end
	end

	def edit
		@user = User.find params[:id]
	end

	def update
		@user = User.find params[:id]
		if @user.update_attributes(params[:user])
			redirect_to observations_path
		else
			flash[:error] = 'Brugeren kunne ikke gemmes'
			render :edit
		end
	end

	def destroy
		@user = User.find(params[:id])

		unless @user.username == 'admin'
			@user.destroy
		else
			flash[:error] = 'Du kan ikke slette admin brugeren'
		end

		redirect_to users_path
	end

end
