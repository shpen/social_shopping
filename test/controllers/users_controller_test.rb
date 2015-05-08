require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get user" do
    user = create(:user)
    get :show, id: user
    assert_response :success
  end

  test "should get all users" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
end
