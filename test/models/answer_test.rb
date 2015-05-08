require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  def setup
    @answer = create(:answer)
  end

  test "should be valid" do
    assert @answer.valid?    
  end

  test "user should be present" do
    @answer.user = nil
    assert_not @answer.valid?
  end

  test "question should be present" do
    @answer.question = nil
    assert_not @answer.valid?
  end

  test "content should be present" do
    @answer.content = "    "
    assert_not @answer.valid?
  end

  test "link should be present" do
    @answer.link = "  "
    assert_not @answer.valid?
  end

  test "link should be valid" do
    @answer.link = "wrong format"
    assert_not @answer.valid?
  end

  test "question user and answer user should be different" do
    @answer.user = @answer.question.user
    assert_not @answer.valid?
  end
end
