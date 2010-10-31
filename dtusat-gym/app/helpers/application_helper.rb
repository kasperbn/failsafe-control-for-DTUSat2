# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def form_errors(o)
		"<div class='flash-error'><ul>"+o.errors.map {|e| "<li>#{e[1]}</li>" }.join+"</ul></div>" if o.errors.size > 0
	end

	def t(s)
		s.strftime('%d/%m-%Y %H:%M')
	end

	## AUTHENTICATION
	def logged_in?
		!current_session.nil?
	end

	def current_user
		current_session.user
	end

	def current_session
		Session.find(session[:id]) rescue nil
	end

	def admin?
		current_user.username == 'admin' rescue false
	end

end
