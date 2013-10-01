class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(params[:video])
    if @video.save
      flash[:success] = "You successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash[:error] = "You cannot add this video. Please check the errors."
      render :new
    end
  end

  private
  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to login_path unless current_user.admin?
    end
  end
end