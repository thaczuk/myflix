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

  def destroy
    queue_video = QueueVideo.find(params[:id])
    queue_video.destroy if current_user.queue_videos.include?(queue_video)
    flash[:notice] = "Video removed from your queue"
    redirect_to my_queue_path
  end

    def update_queue
    params[:queue_videos].each do |queue_video_data|
      queue_video = QueueVideo.find(queue_video_data["id"])
      if !queue_video.update_attributes!(position: queue_video_data["position"])
        flash[:error] = "Invalid position numbers"
        redirect_to my_queue_path
        return
      end
    end
    current_user.queue_videos.each_with_index do |queue_video, index|
      queue_video.update_attributes(position: index + 1)
    end
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