require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @question = create(:question)
  end

  test "should be valid" do
    assert @question.valid?    
  end

  test "user should be present" do
    @question.user = nil
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

  test "all_tags_list should be present" do
    @question.tag_list = "  "
    @question.form_saved = true
    assert_not @question.valid?
  end
end
