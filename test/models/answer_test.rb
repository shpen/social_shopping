require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @question = questions(:one)
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
end
