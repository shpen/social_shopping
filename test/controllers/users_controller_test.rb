require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get user" do
    user = users(:one)
    get :show, id: user
    assert_response :success
  end

  test "should get all users" do
    get :index
    assert_response :success
  end
end
