class SessionsController < ApplicationController
  before_filter :require_user, :only => [ :destroy ]
  before_filter :require_no_user, :only => [ :create ]

  def create
    omniauth = request.env['omniauth.auth']

    authentication = Authentication.where(:provider => omniauth['provider'],
                                          :uid      => omniauth['uid']).first
    if authentication
      flash[:notice] = "Signed in!"
      sign_in_and_redirect(authentication.user)
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'],
                                          :uid      => omniauth['uid'])
      flash[:notice] = 'New authentication added!'
      redirect_to root_url
    else
      user = User.create_from_auth(omniauth)
      sign_in_and_redirect(user)
    end
  end

  def failure
    redirect_to root_url, :alert => "Sorry, we were not able to sign you in."
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  private

  def sign_in_and_redirect(user)
    reset_session
    session[:user_id] = user.id

    redirect_to root_url
  end
end
