require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = create(:user)
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "username should be present" do
  	@user.username = nil
  	assert_not @user.valid?
  end

  test "username should be unique" do
  	@user_other = create(:user)
  	@user_other.username = @user.username
  	assert_not @user_other.save
  end

  test "facebook info should be present with provider set" do
  	@user.provider = 'facebook'
  	assert_not @user.save

  	@user.uid = 1
  	@user.token = "token"
  	@user.expiration = Time.now.to_datetime
  	@user.name = "name"
  	assert @user.save
  end
end
