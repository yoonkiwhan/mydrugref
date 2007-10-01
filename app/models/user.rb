require 'digest/sha1'
class User < ActiveRecord::Base
  has_and_belongs_to_many :friends,
    :class_name => "User",
    :join_table => "friends_users",
    :association_foreign_key => "friend_id",
    :foreign_key => "user_id"
 
  belongs_to :picture, :class_name => 'Attachment', :foreign_key => 'picture_id', :dependent => :destroy

  validates_length_of     :name, :email, :within => 4..100
  validates_uniqueness_of :email
  validates_format_of     :email, :with => /^(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))?$/

  def first_name; name.split.first; end
  def last_name;  name.split.last; end
  def short_name; name.blank? ? "" : "#{first_name} #{last_name[0,1]}."; end
  def doc_name; name.blank? ? "" : "Dr. #{last_name}"; end

  # Makes an attachment from a thumbnail upload
  def file= file
    unless file.size == 0
      picture = Attachment.new :content => file.read
      picture.save
      write_attribute 'picture_id', picture.id
    end
  end
  
def validate
  errors.add_to_base("Missing password") if hashed_password.blank?
end

def password
  @password
end

def password=(pwd)
  @password = pwd
  return if pwd.blank?
  create_new_salt
  self.hashed_password = User.encrypted_password(self.password, self.salt)
end

def self.authenticate(email, password)
  user = self.find_by_email(email)
  if user
    expected_password = encrypted_password(password, user.salt)
    if user.hashed_password != expected_password
      user = nil
    end
  end
  user
end

def after_destroy
  if User.count.zero?
    raise "Can't delete last user"
  end
end

private

def self.encrypted_password(password, salt)
  string_to_hash = password + "wibble" + salt
  Digest::SHA1.hexdigest(string_to_hash)
end

def create_new_salt
  self.salt = self.object_id.to_s + rand.to_s
end
end

