require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get user" do
    get :show, id: '0'
    assert_response :success
  end

  test "should get user list" do
    get :list
    assert_response :success
  end
end
