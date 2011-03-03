class ApplicationController < ActionController::Base
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '18edbcc72166d0e0e95b0658d472965b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :permission_denied
  
  layout "application"
  
  protected
    def permission_denied
      store_location
      flash[:notice] = "You don't have the power for that."
      redirect_to new_user_session_url
      return false
    end
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
      
    def require_admin
      unless (current_user && current_user.admin?)
        store_location
        flash[:notice] = "You do not have access to this page"
        redirect_to new_user_session_url
        return false
      end
    end
    
    def require_owner(user)
      unless(current_user && (current_user.admin? || current_user == user))
        store_location
        flash[:notice] = "You do not have access to this page"
        redirect_to new_user_session_url
        return false
      end
    end
    
    def require_player_for(league)
      unless current_user && league.players.include?(current_user)
        store_location
        flash[:notice] = "You do not have access to this page"
        if current_user
          redirect_to player_url(current_user)
        else
          redirect_to new_user_session_url
        end
        return false
      end
    end
    
    def sort_order(default)
      if params[:c] && params[:c] == 'skill'
        "throw_level_id+ability_id #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
      else
        "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
      end
    end  
end
