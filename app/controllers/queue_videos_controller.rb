class QueueVideosController < ApplicationController
before_filter   :require_user

  def index
    @queue_videos = current_user.queue_videos
  end
end