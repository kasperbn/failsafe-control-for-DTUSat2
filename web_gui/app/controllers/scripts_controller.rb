class ScriptsController < ApplicationController

	def new
		@script = Script.new
	end

	def index
		@scripts = Script.all
	end

	def create
		@script = Script.new(params[:script])
		if @script.save
			flash[:notice] = "Scriptet blev oprettet"
			redirect_to scripts_path
		else
			flash[:error] = "Scriptet kunne ikke gemmes"
			render :new
		end
	end

	def edit
		@script =	Script.find(params[:id])
	end

	def update
		@script =	Script.find(params[:id])
		if @script.update_attributes(params[:script])
			flash[:notice] = "Scriptet blev oprettet"
			redirect_to scripts_path			
		else
			flash[:error] = "Scriptet kunne ikke gemmes"
			render :edit
		end
	end
	
	def destroy
		Script.find(params[:id]).destroy
		redirect_to scripts_path
	end

end
