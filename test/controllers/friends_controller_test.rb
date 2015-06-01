require 'test_helper'

class FriendsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @friend_request = create(:friend_request)
    @friendship = create(:friendship)
    @friendship_mirror = create(:friendship, user: @friendship.friend, friend: @friendship.user)
    @user = create(:user)
    @user_other = create(:user)
  end


  # Login redirects

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to new_user_session_url
  end

  test "should redirect friend_request when not logged in" do
    assert_no_difference 'FriendRequest.count' do
      post :request_friend, id: @user_other
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect accept when not logged in" do
    assert_no_difference 'FriendRequest.count' do
      assert_no_difference 'Friendship.count' do
        put :accept, id: @friend_request
      end
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect decline when not logged in" do
    assert_no_difference 'FriendRequest.count' do
      delete :decline, id: @friend_request
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect delete when not logged in" do
    assert_no_difference 'Friendship.count' do
      delete :delete, id: @friendship
    end
    assert_redirected_to new_user_session_url
  end


  # Simple login successes

  test "should get all friends" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:outgoing)
    assert_not_nil assigns(:incoming)
    assert_not_nil assigns(:friends)
  end

  test "should send friend_request when logged in" do
    sign_in @user
    assert_difference 'FriendRequest.count' do
      post :request_friend, id: @user_other
    end
    assert_redirected_to request.referrer || root_url
  end


  # Incorrect user login redirects

  test "should redirect accept when logged in as wrong user" do
    sign_in @user
    assert_no_difference 'FriendRequest.count' do
      assert_no_difference 'Friendship.count' do
        put :accept, id: @friend_request
      end
    end
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect accept when logged in as requester" do
    sign_in @friend_request.user
    assert_no_difference 'FriendRequest.count' do
      assert_no_difference 'Friendship.count' do
        put :accept, id: @friend_request
      end
    end
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect decline when logged in as wrong user" do
    sign_in @user
    assert_no_difference 'FriendRequest.count' do
      delete :decline, id: @friend_request
    end
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect delete when logged in as wrong user" do
    sign_in @user
    assert_no_difference 'Friendship.count' do
      delete :delete, id: @friendship
    end
    assert_redirected_to request.referrer || root_url
  end


  # Specific user login successes

  test "should accept friend request when logged in as requestee" do
    sign_in @friend_request.friend
    assert_difference('FriendRequest.count', -1) do
      assert_difference('Friendship.count', 2) do
        put :accept, id: @friend_request
      end
    end
    assert_redirected_to request.referrer || root_url
  end

  test "should cancel friend request when logged in as requester" do
    sign_in @friend_request.user
    assert_difference('FriendRequest.count', -1) do
      delete :decline, id: @friend_request
    end
    assert_redirected_to request.referrer || root_url
  end

  test "should decline friend request when logged in as requestee" do
    sign_in @friend_request.friend
    assert_difference('FriendRequest.count', -1) do
      delete :decline, id: @friend_request
    end
    assert_redirected_to request.referrer || root_url
  end

  test "should delete friendship when logged in" do
    sign_in @friendship.user
    assert_difference('Friendship.count', -2) do
      delete :delete, id: @friendship.friend
    end
    assert_redirected_to request.referrer || root_url
  end
end
