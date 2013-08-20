class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])

    if @user.save
      flash[:success] = "You are registered. Please sign in."
      redirect_to sign_in_path
    else
      render :new
    end
  end
end