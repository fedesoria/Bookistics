class SessionsController < ApplicationController
  before_filter :require_user, :only => [ :destroy ]
  before_filter :require_no_user, :only => [ :create ]

  def create
    omniauth = request.env['omniauth.auth']

    authentication = Authentication.where(:provider => omniauth['provider'],
                                          :uid      => omniauth['uid']).first
    if authentication
      flash[:notice] = "Signed in!"
      sign_in_and_redirect(authentication.user, omniauth)
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'],
                                          :uid      => omniauth['uid'])
      flash[:notice] = 'New authentication added!'
      redirect_to root_url
    else
      user = User.create_from_auth(omniauth)
      sign_in_and_redirect(user, omniauth)
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

  def sign_in_and_redirect(user, auth)
    reset_session
    session[:user_id] = user.id
    session[:user_auth] = auth

    # Temporal fix to update already existing profiles with these fields.
    # This only works for twitter, since its the only provider we use at the moment.
    if auth['user_info']
      attributes = {}

      attributes[:name]       = auth['user_info']['name'] if auth['user_info']['name']
      attributes[:avatar_url] = auth['user_info']['image'] if auth['user_info']['image']
      attributes[:nickname]   = auth['user_info']['nickname'] if auth['user_info']['nickname']

      user.update_attributes! attributes unless attributes.empty?
    end

    redirect_to root_url
  end
end
