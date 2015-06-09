class AddFacebookToFriendshipsAndFriendRequests < ActiveRecord::Migration
  def change
    add_column :friendships, :facebook, :boolean
    add_column :friend_requests, :facebook, :boolean
  end
end
