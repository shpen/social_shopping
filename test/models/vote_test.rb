require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @question_vote = create(:vote, :for_question)
    @answer_vote = create(:vote, :for_answer)
  end

  test "question vote should be valid" do
    assert @question_vote.valid?    
  end

  test "answer vote should be valid" do
    assert @answer_vote.valid?    
  end

  test "user cannot vote for own question" do
    @question_vote.voter = @question_vote.votable.user
    assert_not @question_vote.valid?
  end

  test "user cannot vote for own answer" do
    @answer_vote.voter = @answer_vote.votable.user
    assert_not @answer_vote.valid?
  end
end