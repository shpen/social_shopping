require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get question" do
    question = questions(:one)
    get :show, id: question
    assert_response :success
  end

  test "should get all questions" do
    get :index
    assert_response :success
  end
end
