class User < ActiveRecord::Base
  has_many  :queue_videos
  has_secure_password
  validates :email, :full_name, :password, :presence =>true
  validates_uniqueness_of :email
end