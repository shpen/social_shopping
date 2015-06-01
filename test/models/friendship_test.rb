require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @friendship = create(:friendship)
  end

  test "should be valid" do
    assert @friendship.valid?  
  end

  test "user should be present" do
    @friendship.user = nil
    assert_not @friendship.valid?
  end

  test "friend should be present" do
    @friendship.friend = nil
    assert_not @friendship.valid?
  end

  test "user and friend should be different" do
    @friendship.user = @friendship.friend
    assert_not @friendship.valid?
  end
end
