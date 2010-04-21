class ObservationsController < ApplicationController

	before_filter :require_login
	before_filter :require_owning_user, :except => [:index, :new, :create, :export]

	def index
		@observations = if admin? || params[:filter] == 'all'
			Observation.all :order => 'created_at DESC'
		else
			current_user.observations :order => 'created_at DESC'
		end
	end

	def new
		@observation = if admin?
			Observation.new
		else
			Observation.new :position => current_user.position
		end
	end

	def create
		@observation = Observation.new params[:observation]
		@observation.user_id = current_user.id unless admin?

		if @observation.save
			redirect_to observations_path
		else
			flash[:error] = "Observationen kunne ikke gemmes"
			render :new
		end
	end

	def edit
		@observation = Observation.find params[:id]
	end

	def update
		@observation = Observation.find params[:id]
		@observation.user_id = current_user.id unless admin?

		if @observation.update_attributes(params[:observation])
			redirect_to observations_path
		else
			flash[:error] = "Observationen kunne ikke gemmes"
			render :edit
		end
	end

	def destroy
		@observation = Observation.find params[:id]
		@observation.destroy
		redirect_to observations_path
	end

  def export
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="observationer_'+Time.now.strftime('%d-%m-%Y')+'.xls"'
    headers['Cache-Control'] = ''
		index
    render :layout => false
  end

	private
	def require_owning_user
		unless admin? || Observation.count(:conditions => ['id = ? AND user_id = ?', params[:id], current_user.id]) > 0
			flash[:error] = 'Ingen adgang her!'
			redirect_to observations_path
		end
	end

end
