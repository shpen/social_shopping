class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend_request, only: [:accept, :decline]

  # GET /friends
  def index
    @incoming = FriendRequest.where(friend: current_user)
    @outgoing = current_user.friend_requests
    @friends = current_user.friends
  end

  # POST /users/:id/friend_request
  def request_friend
    friend = User.find(params[:id])

    # Check if this user has already requested us
    if friend.pending_friends.include? current_user
      FriendRequest.find(user: friend, friend: current_user).accept
      flash[:success] = "You are now friends with #{friend.username}"
    else
      friend_request = current_user.friend_requests.build(friend: friend)

      if friend_request.save
        flash[:success] = "Friend request sent."
      else
        flash[:danger] = "Unable to send friend request."
      end
    end

    redirect_to request.referrer || root_url
  end

  # PUT /friends_requests/:id/accept
  def accept
    if @friend_request.friend == current_user
      @friend_request.accept
    else
      flash[:danger] = "You cannot accept a friend request directed at someone else."
    end

    redirect_to request.referrer || root_url
  end

  # DELETE /friends_requests/:id/decline
  def decline
    if @friend_request.friend == current_user || @friend_request.user == current_user
      @friend_request.destroy
    else
      flash[:danger] = "You cannot cancel a friend request that does not involve you."
    end

    redirect_to request.referrer || root_url
  end

  # DELETE /friends/:id/delete
  def delete
    friend = current_user.friends.find_by_id(params[:id])
    if friend.nil?
      flash[:danger] = "Unable to delete non-existent friendship."
    else
      current_user.friends.destroy(friend)
      friend.friends.destroy(current_user)
    end

    redirect_to request.referrer || root_url
  end

  # GET /friends/facebook
  def facebook
    @facebook_friends = current_user.query_facebook_for_friends.where.not(id: current_user.friends + current_user.pending_friends)
  end

  # POST /friends/facebook
  def facebook_add
    # Delete the blank id and convert to ints first
    ids = (params[:user][:facebook_friends] - [""]).map { |friend_id| friend_id.to_i }
    User.where(id: ids).each do |friend|
      if friend.pending_friends.include? current_user
        FriendRequest.find_by(user: friend, friend: current_user).accept
      else
        friend_request = current_user.friend_requests.create(friend: friend, facebook: true)
      end
    end

    redirect_to action: 'index'
  end

  private
    def set_friend_request
      @friend_request = FriendRequest.find_by_id(params[:id])
      if @friend_request.nil?
        redirect_to(request.referrer || root_url, flash: { danger: 'Friend request not found.' })
      end
    end
end
