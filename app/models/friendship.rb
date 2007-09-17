class Friendship < ActiveRecord::Base
belongs_to :friendshipped,
    :foreign_key => "user_id",
    :class_name => "User"
  belongs_to :befriendshipped,
    :foreign_key => "friend_id",
    :class_name => "User"
    
end
