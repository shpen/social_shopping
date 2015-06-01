require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @friend_request = create(:friend_request)
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
end
