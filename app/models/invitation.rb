class Invitation < ActiveRecord::Base
include Tokenable

  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_name, :recipient_email, :message
  validates_format_of :recipient_email, :with => /@/
end