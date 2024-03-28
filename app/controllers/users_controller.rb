class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # @book_count_this_week = @books.created_this_week.count
    # @book_count_last_week = @books.created_last_week.count
    # if @book_count_day != 0 && @book_count_yesterday != 0
    #   @book_count_ratio_day = (@book_count_day / @book_count_yesterday) * 100
    # else
    #   @book_count_ratio_day = "---"
    # end
    # if @book_count_this_week != 0 && @book_count_last_week != 0
    #   @book_count_ratio_week = (@book_count_this_week / @book_count_last_week) * 100
    # else
    #   @book_count_ratio_week = "---"
    # end

    @days_record = @books.group("strftime(created_at,'%Y-%m-%d')").count
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
