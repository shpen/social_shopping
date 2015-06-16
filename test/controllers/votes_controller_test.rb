require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @question = create(:question)
    @answer = create(:answer)
    @user = create(:user)
  end

  test "should return unauthorized when not logged in" do
    assert_no_difference '@question.cached_votes_score' do
      xhr :get, :vote, votable: @question.class, id: @question, vote: 'true'
      @question.reload
    end
    assert_response :unauthorized
  end

  test "should reutrn unauthorized if user votes for self" do
    sign_in @question.user
    assert_no_difference '@question.cached_votes_score' do
      xhr :get, :vote, votable: @question.class, id: @question, vote: 'true'
      @question.reload
    end
    assert_response :unauthorized
  end

  test "should succeed at voting for question" do
    sign_in @user
    assert_difference '@question.cached_votes_score' do
      xhr :get, :vote, votable: @question.class, id: @question, vote: 'true'
      @question.reload
    end
  end

  test "should succeed at voting for answer" do
    sign_in @user
    assert_difference '@answer.cached_votes_score' do
      xhr :get, :vote, votable: @answer.class, id: @answer, vote: 'true'
      @answer.reload
    end
  end

  test "should succeed at downvoting" do
    sign_in @user
    assert_difference('@question.cached_votes_score', -1) do
      xhr :get, :vote, votable: @question.class, id: @question, vote: 'false'
      @question.reload
    end
  end

  test "should succeed at unvoting" do
    @user.up_votes @question
    sign_in @user
    assert_difference('@question.cached_votes_score', -1) do
      xhr :get, :vote, votable: @question.class, id: @question, vote: 'true'
      @question.reload
    end
  end
end
