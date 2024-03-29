class User < ActiveRecord::Base
include Tokenable

  has_many  :queue_videos, order: :position
  has_many :reviews, order: "created_at DESC"
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password

  validates :email, :full_name, :password, :presence =>true
  validates_uniqueness_of :email
  validates_format_of :email, :with => /@/

  def normalize_queue_video_positions
    queue_videos.each_with_index do |queue_video, index|
      queue_video.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_videos.map(&:video).include?(video)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def deactivate!
    update_column(:active, false)
  end
end