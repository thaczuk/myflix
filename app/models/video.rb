class Video < ActiveRecord::Base
  has_one :category

  validates :title, :description, presence: true
end