=begin
class ActsAsVotable::Vote < ActiveRecord::Base
  validate :user_cannot_vote_for_self

  def user_cannot_vote_for_self
    if !votable.nil? && votable.user == voter
      errors[:base] << "You cannot vote for yourself"
    end
  end
end
=end