require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @friend_request = create(:friend_request)
    @facebook_request = create(:friend_request, facebook: true)
  end

  test "should be valid" do
    assert @friend_request.valid?  
  end

  test "user should be present" do
    @friend_request.user = nil
    assert_not @friend_request.valid?
  end

  test "friend should be present" do
    @friend_request.friend = nil
    assert_not @friend_request.valid?
  end

  test "user and friend should be different" do
    @friend_request.user = @friend_request.friend
    assert_not @friend_request.valid?
  end

  test "accept should create friendships" do
    assert_difference('FriendRequest.count', -1) do
      assert_difference('Friendship.count', 2) do
        @facebook_request.accept
      end
    end
    assert Friendship.last.facebook
    assert Friendship.all[-2].facebook
  end
end
