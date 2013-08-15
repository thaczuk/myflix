class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(params[:review].merge!(user: current_user))

    if review.save
      redirect_to @video
    else
      flash[:error] = "Don't forget to enter your review!"
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end
end
