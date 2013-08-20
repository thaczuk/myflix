module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map {|x| [pluralize(x, "Star"), x]}, selected)
  end
end
