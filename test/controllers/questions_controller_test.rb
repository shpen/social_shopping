require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @question = create(:question)
    @user = @question.user
    @user_wrong = create(:user)
  end

  test "should get question" do
    get :show, id: @question
    assert_response :success
  end

  test "should get all questions" do
    get :index
    assert_response :success
    assert_not_nil assigns(:questions)
  end


  # Login redirects

  test "should redirect new when not logged in" do
    get :new
    assert_redirected_to new_user_session_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Question.count' do
      post :create, question: { title: 'Title' }
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @question
    assert_redirected_to new_user_session_url
  end

  test "should redirect update when not logged in" do
    title = @question.title
    put :update, id: @question, question: { title: 'New Title' }
    assert_equal title, Question.find(@question.id).title
    assert_redirected_to new_user_session_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Question.count' do
      delete :destroy, id: @question
    end
    assert_redirected_to new_user_session_url
  end


  # Simple login successes

  test "should show new when logged in" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should show create when logged in" do
    sign_in @user
    assert_difference 'Question.count' do
      post :create, question: { title: 'Title', tag_list: "tag" }
    end
    assert_redirected_to Question.last
  end


  # Incorrect user login redirects

  test "should redirect edit when logged in as wrong user" do
    sign_in @user_wrong
    get :edit, id: @question
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect update when logged in as wrong user" do
    sign_in @user_wrong
    title = @question.title
    put :update, id: @question, question: { title: 'New Title' }
    assert_equal title, Question.find(@question.id).title
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect destroy when logged in as wrong user" do
    sign_in @user_wrong
    assert_no_difference 'Question.count' do
      delete :destroy, id: @question
    end
    assert_redirected_to request.referrer || root_url
  end


  # Specific user login successes

  test "should show edit when logged in" do
    sign_in @user
    get :edit, id: @question
    assert_response :success
  end

  test "should update when logged in" do
    sign_in @user
    title = 'New Title'
    put :update, id: @question, question: { title: title }
    assert_equal title, Question.find(@question.id).title
    assert_redirected_to @question
  end

  test "should destroy when logged in" do
    sign_in @user
    assert_difference('Question.count', -1) do
      delete :destroy, id: @question
    end
    assert_redirected_to questions_url
  end

end
