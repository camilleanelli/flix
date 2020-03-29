class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email_or_username]) || User.find_by(username: params[:email_or_username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:toto] || user, notice: "Welcome back #{user.name}"
    else
      flash.now[:alert] = "Wrong combination password / email"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, alert: "you're no longer signed in"
  end
end
