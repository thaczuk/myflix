class User < ActiveRecord::Base


  validates :email, :full_name, :password, :presence =>true
  validates_uniqueness_of :email
  has_secure_password

end