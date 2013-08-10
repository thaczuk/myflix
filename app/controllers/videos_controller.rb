class VideosController < ApplicationController
  def index
    #@videos = Video.all
    @category = Category.all
  end

  def show
    @video = Video.find params[:id]
  end

  def search
    @videos = Video.search_by_title(params[:search_term] )
  end
end