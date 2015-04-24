require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @question = questions(:two)
    @answer = @user.answers.build(question: @question, content: "Content")
  end

  test "should be valid" do
    assert @answer.valid?    
  end

  test "user id should be present" do
    @answer.user_id = nil
    assert_not @answer.valid?
  end

  test "content should be present" do
    @answer.content = "    "
    assert_not @answer.valid?
  end

  test "question user and answer user should be different" do
    @answer.user = @question.user
    assert_not @answer.valid?
  end
end
