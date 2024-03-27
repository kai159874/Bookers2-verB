class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    today = Date.today
    yesterday = today - 1
    current_week = ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)
    prev_week = ((Time.current.at_end_of_day - 13.day).at_beginning_of_day)..(Time.current.at_end_of_day - 6.day)
    @book_count_day = @books.where(created_at: today.all_day).count
    @book_count_yesterday = @books.where(created_at: yesterday.all_day).count
    @book_count_current_week = @books.where(created_at: current_week).count
    @book_count_prev_week = @books.where(created_at: prev_week).count
    if @book_count_day != 0 && @book_count_yesterday != 0
      @book_count_ratio_day = (@book_count_day / @book_count_yesterday) * 100
    else
      @book_count_retio_day = nil
    end
    if @book_count_current_week != 0 && @book_count_prev_week != 0
      @book_count_ratio_week = (@book_count_current_week / @book_count_prev_week) * 100
    else
      @book_count_retio_day = nil
    end
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
