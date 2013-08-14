class SessionsController < ApplicationController
  before_filter :require_user, only: [:destroy]

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to home_path, notice: 'Welcome, you are logged in.'
    else
        flash[:error] = "Email or password is incorrect, or not registered."
        redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out"
  end
end