require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @question = @user.questions.build(title: "title")
  end

  test "should be valid" do
    assert @question.valid?    
  end

  test "user id should be present" do
    @question.user_id = nil
    assert_not @question.valid?
  end

  test "title should be present" do
    @question.title = "    "
    assert_not @question.valid?
  end

  test "description can be empty" do
    @question.description = ""
    assert @question.valid?
  end
end
