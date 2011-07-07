class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.where(:provider => auth['provider'],
                      :uid      => auth['uid']).first || User.create_with_auth(auth)

    reset_session
    session[:user_id] = user.id

    redirect_to root_url
  end

  def failure
    redirect_to root_url, :alert => "Sorry, we were not able to sign you in."
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
