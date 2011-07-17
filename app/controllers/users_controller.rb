class UsersController < ApplicationController
  def show
    @user = User.find_by_name(params[:id], :include => [ :books ])
  end
end
