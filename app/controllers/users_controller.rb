class UsersController < ApplicationController
  def show
    @user = User.find_by_name(params[:id])
    @books = @user.books if @user
  end
end
