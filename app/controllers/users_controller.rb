class UsersController < ApplicationController
  def index
    @users = User
               .paginate(:page => params[:page])
               .order("created_at DESC")
  end

  def show
    if User.param_exists? params[:id]
      @user                = User.from_param(params[:id])
      @reading_books       = Book.user_reading_books(@user)
      @read_books          = Book.user_read_books(@user)
      @wants_to_read_books = Book.user_wants_to_read_books(@user)
    else
      redirect_to_root_with_error("User not found")
    end
  end
end
