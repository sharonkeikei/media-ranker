class ApplicationController < ActionController::Base
  
  def find_current_user
    if session[:user_id]
      return @current_user = User.find_by(id: session[:user_id])
    end
  end

  def require_login
    if find_current_user.nil?
      flash[:error] = "Sorry! You must be logged in to upvote!"
      redirect_back(fallback_location: root_path)
    end
  end
end
