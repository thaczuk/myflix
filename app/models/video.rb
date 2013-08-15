class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    if search_term.blank?
      {}
    else
      where("title LIKE ?", "%#{ search_term}%")
    end
  end

  def average_ratings
    if reviews.size > 0
      (reviews.collect(&:rating).sum.to_f / reviews.size).round(1)
    else
      0
    end
  end

  def recent_reviews
    reviews.order("created_at desc")
  end
end