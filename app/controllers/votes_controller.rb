class VotesController < ApplicationController
  before_action :authenticate_user!

  def vote
    votable = params[:model_class].constantize.find(params[:id])
    voted = current_user.voted_as_when_voted_for votable

    # Unvote
    if (voted && params[:vote] == 'true') || (voted == false && params[:vote] == 'false')
      current_user.unvote_for votable
      @result = nil

    # Upvote
    elsif params[:vote] == 'true'
      current_user.up_votes votable
      @result = true

    # Downvote
    else
      current_user.down_votes votable
      @result = false
    end

    @score = votable.cached_votes_score

    respond_to do |format|
      format.js
    end
  end
end