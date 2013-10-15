class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    @object.average_ratings.present? ? "#{ object.average_ratings }/5.0" : "N/A"
  end

end