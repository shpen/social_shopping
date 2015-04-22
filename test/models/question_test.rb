require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @question = @user.questions.build(content: "Content")
  end

  test "should be valid" do
    assert @question.valid?    
  end

  test "user id should be present" do
    @question.user_id = nil
    assert_not @question.valid?
  end

  test "content should be present" do
    @question.content = "    "
    assert_not @question.valid?
  end
end
