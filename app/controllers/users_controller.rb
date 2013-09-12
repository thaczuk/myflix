class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])

    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      flash[:success] = "You are registered. Please sign in."
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
end