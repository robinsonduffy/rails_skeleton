class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
    def access_denied
      flash[:error] = "You are not authorized to view that page"
      redirect_to login_path
    end
    
    def require_admin
      if !current_user || !current_user.admin
        access_denied
      end
    end
  
end
