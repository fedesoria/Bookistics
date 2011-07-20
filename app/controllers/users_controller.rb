class UsersController < ApplicationController

  NUM_OF_USERS_ON_INDEX = 15

  def index
    @users = User.order("created_at DESC").limit(NUM_OF_USERS_ON_INDEX)
  end

  def show
    redirect_to_root_with_error("User not found") unless
      @user = User.find_by_name(User.unescape(params[:id]), :include => [ :reading_logs, :books ])
  end
end
