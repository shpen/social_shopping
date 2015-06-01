class FriendRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence: true

  validate :not_self

  def not_self
    if user == friend
      errors[:base] << "You cannot friend request yourself."
    end
  end

  def accept
    user.friends << friend
    friend.friends << user
    destroy
  end
end
