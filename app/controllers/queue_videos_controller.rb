class QueueVideosController < ApplicationController
before_filter   :require_user

  def index
    @queue_videos = current_user.queue_videos
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueVideo.create(video: video, user: current_user, position: new_queue_video_position) unless current_user_queued_video?(video)
  end

  def new_queue_video_position
    current_user.queue_videos.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_videos.map(&:video).include?(video)
  end
end