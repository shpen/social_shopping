class VotesController < ApplicationController
  before_action :authenticate_user!

  def vote
    votable = params[:votable].constantize.find(params[:id])
    voted = current_user.voted_as_when_voted_for votable

    # Unvote
    if (voted && params[:vote] == 'true') || (voted == false && params[:vote] == 'false')
      current_user.unvote_for votable

    # Upvote
    elsif params[:vote] == 'true'
      current_user.up_votes votable

    # Downvote
    else
      current_user.down_votes votable
    end

    @result = current_user.voted_as_when_voted_for votable
    @score = votable.cached_votes_score

    respond_to do |format|
      format.js
    end
  end
end