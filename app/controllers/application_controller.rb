class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :signed_in?

  def index
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def require_user
    unless signed_in?
      store_location
      flash[:notice] = "You really need to be logged in to do that!"
      redirect_to root_url
      return false
    end
  end

  def require_no_user
    if signed_in?
      flash[:notice] = "You are already logged in!"
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_to_root_with_error(error_message)
    flash[:notice] = error_message
    redirect_to root_url
  end
end
