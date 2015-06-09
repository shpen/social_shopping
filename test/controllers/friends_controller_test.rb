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

  test "should redirect facebook when not logged in" do
    get :facebook
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

  test "should show facebook friends when logged in" do
    sign_in @user
    @user.uid = 101450360195871
    @user.token = 'CAAUQQRyHjckBALyiZAzcHKEwT0nWbAZBHjDG79fj69GMCuEgPr7VLWZBQ5ZAU5fDSZASwcTJCes7wfhIAoo0gUwBti5ZASfHhvVuqWdcLEQuakwBK7KkoWOLHbAbnMVdz1NCtN42ZB1GJZA967Wnyx8ldAbz3YCPj6ojutZC5ln1Ffrbi91OHYcT5vPBUXXRVqvT0Nv1n1wdDyQwwBuUwklZAR'
    @user.save
    get :facebook
    assert_response :success
    assert_not_nil assigns(:facebook_friends)
  end

  test "should request facebook friends when logged in" do
    sign_in @user
    assert_difference 'FriendRequest.count' do
      post :facebook_add, user: { facebook_friends: ["", "#{@user_other.id}"] }
    end
    assert FriendRequest.last.facebook
    assert_redirected_to action: 'index'
  end

  test "should auto add facebook friends when logged in" do
    @user_other.friend_requests.create(friend: @user, facebook: true)
    sign_in @user
    assert_difference('FriendRequest.count', -1) do
      assert_difference('Friendship.count', 2) do
        post :facebook_add, user: { facebook_friends: ["", "#{@user_other.id}"] }
      end
    end
    assert Friendship.last.facebook
    assert Friendship.all[-2].facebook
    assert_redirected_to action: 'index'
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
