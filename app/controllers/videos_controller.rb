class VideosController < AuthenticatedController
  before_filter :require_user

  def index
    @category = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find params[:id])
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params[:search_term] )
  end
end