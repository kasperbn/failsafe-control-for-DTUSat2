class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
	include ApplicationHelper

	private
  def require_login
    unless logged_in?
      flash[:error] = "Log venligst ind"
      redirect_to new_session_path
    end
  end

  def require_admin
    unless admin?
      flash[:error] = "Ingen adgang her!"
      redirect_to observations_path
    end
  end

   def require_current_id_unless_admin
    unless admin? || params[:id].to_i == current_user.id
      flash[:error] = "Ingen adgang her!"
      redirect_to observations_path
    end
  end

end
