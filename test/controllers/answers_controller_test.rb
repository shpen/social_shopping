require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @answer = answers(:one)
    @question = questions(:one)
    @question_wrong = questions(:two)
    @user = users(:two)
    @user_wrong = users(:one)
  end

  test "should get answer" do
    get :show, question_id: @question, id: @answer
    assert_response :success
  end


  # Login redirects

  test "should redirect new when not logged in" do
    get :new, question_id: @question
    assert_redirected_to new_user_session_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Answer.count' do
      post :create, question_id: @question, answer: { content: "Content" }
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect edit when not logged in" do
    get :edit, question_id: @question, id: @answer
    assert_redirected_to new_user_session_url
  end

  test "should redirect update when not logged in" do
    content = @answer.content
    put :update, question_id: @question, id: @answer, answer: { content: "New Content" }
    assert_equal content, Answer.find(@answer.id).content
    assert_redirected_to new_user_session_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Answer.count' do
      delete :destroy, question_id: @question, id: @answer
    end
    assert_redirected_to new_user_session_url
  end


  # Simple login successes

  test "should show new when logged in" do
    sign_in @user
    get :new, question_id: @question
    assert_response :success
  end

  test "should show create when logged in" do
    sign_in @user
    assert_difference 'Answer.count' do
      post :create, question_id: @question, answer: { content: "Content" }
    end
    assert_redirected_to question_answer_url(@question, Answer.last)
  end


  # Incorrect user login redirects

  test "should redirect edit when logged in as wrong user" do
    sign_in @user_wrong
    get :edit, question_id: @question, id: @answer
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect update when logged in as wrong user" do
    sign_in @user_wrong
    content = @answer.content
    put :update, question_id: @question, id: @answer, answer: { content: "New Content" }
    assert_equal content, Answer.find(@answer.id).content
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect destroy when logged in as wrong user" do
    sign_in @user_wrong
    assert_no_difference 'Answer.count' do
      delete :destroy, question_id: @question, id: @answer
    end
    assert_redirected_to request.referrer || root_url
  end

  # Specific user login successes

  test "should show edit when logged in" do
    sign_in @user
    get :edit, question_id: @question, id: @answer
    assert_response :success
  end

  test "should update when logged in" do
    sign_in @user
    content = "New Content"
    put :update, question_id: @question, id: @answer, answer: { content: content }
    assert_equal content, Answer.find(@answer.id).content
    assert_redirected_to question_answer_url(@question, @answer)
  end

  test "should destroy when logged in" do
    sign_in @user
    assert_difference('Answer.count', -1) do
      delete :destroy, question_id: @question, id: @answer
    end
    assert_redirected_to @question
  end
end
