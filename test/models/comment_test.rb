require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = create(:comment, :for_question)
    @comment_answer = create(:comment, :for_answer)
  end

  test "should be valid" do
    assert @comment.valid?
    assert @comment_answer.valid?
  end

  test "user should be present" do
    @comment.user = nil
    assert_not @comment.valid?
  end

  test "commentable should be present" do
  	@comment.commentable = nil
  	assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.content = "    "
    assert_not @comment.valid?
  end
end
