class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, except: [:new, :create, :index, :show, :destroy]
  before_action :require_admin, only: [:destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.not_admin
  end

  def show
    @reviews = @user.reviews
    @movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params_user)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signup !"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(params_user)
      redirect_to @user, notice: "Account updated!"
    else
      render :edit 
    end
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      redirect_to root_path, alert: "Your account is deleted"
    else
      render :show
    end
  end

  private

  def set_user
    @user = User.find_by username: params[:id]
  end

  def require_correct_user
    @user = User.find_by! username: params[:id]
    redirect_to root_path unless current_user?(@user)
  end

  def params_user
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :username)
  end
end
