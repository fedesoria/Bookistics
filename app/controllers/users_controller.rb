class UsersController < ApplicationController
  def index
    @users = User
               .paginate(:page => params[:page])
               .order("created_at DESC")
  end

  def show
    if User.where('name = ?', User.unescape(params[:id])).exists?
      @user = User.find_by_name(User.unescape(params[:id]))
      @books = Book
        .includes(:reading_logs)
        .where('reading_logs.user_id = ?', @user.id)
        .paginate(:page => params[:page])
    else
      redirect_to_root_with_error("User not found")
    end
  end
end
