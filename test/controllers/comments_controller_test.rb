require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = create(:user)
    @question = create(:question)
    @answer = create(:answer)
    @comment = create(:comment, :for_question)
  end


  # Login redirects

  test "should redirect new when not logged in" do
    get :new, comment: { commentable_id: @question, commentable_type: @question.class }
    assert_redirected_to new_user_session_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post :create, comment: { commentable_id: @question, commentable_type: @question.class, content: "content" }
    end
    assert_redirected_to new_user_session_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @comment
    assert_redirected_to new_user_session_url
  end

  test "should redirect update when not logged in" do
    content = @comment.content
    put :update, id: @comment, comment: { content: 'New content' }
    assert_equal content, Comment.find(@comment.id).content
    assert_redirected_to new_user_session_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete :destroy, id: @comment
    end
    assert_redirected_to new_user_session_url
  end


  # Simple login successes

  test "should show new when logged in" do
    sign_in @user
    get :new, comment: { commentable_id: @question, commentable_type: @question.class }
    assert_response :success
  end

  test "should create when logged in" do
    sign_in @user
    assert_difference 'Comment.count' do
      post :create, comment: { commentable_id: @question, commentable_type: @question.class, content: "content" }
    end
    assert_redirected_to @question
  end


  # Incorrect user login redirects

  test "should redirect edit when logged in as wrong user" do
    sign_in @user
    get :edit, id: @comment
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect update when logged in as wrong user" do
    sign_in @user
    content = @comment.content
    put :update, id: @comment, comment: { content: 'New content' }
    assert_equal content, Comment.find(@comment.id).content
    assert_redirected_to request.referrer || root_url
  end

  test "should redirect destroy when logged in as wrong user" do
    sign_in @user
    assert_no_difference 'Comment.count' do
      delete :destroy, id: @comment
    end
    assert_redirected_to request.referrer || root_url
  end


  # Specific user login successes

  test "should show edit when logged in" do
    sign_in @comment.user
    get :edit, id: @comment
    assert_response :success
  end

  test "should update when logged in" do
    sign_in @comment.user
    content = 'New content'
    put :update, id: @comment, comment: { content: content }
    assert_equal content, Comment.find(@comment.id).content
    assert_redirected_to @comment.commentable
  end

  test "should destroy when logged in" do
    sign_in @comment.user
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment
    end
    assert_redirected_to @comment.commentable
  end


  # Other failures

  test "should redirect when attempting to comment on non-commentable" do
    sign_in @user
    assert_no_difference 'Comment.count' do
      post :create, comment: { commentable_id: @user, commentable_type: @user.class, content: "content" }
    end
    assert_redirected_to request.referrer || root_url
  end
end
