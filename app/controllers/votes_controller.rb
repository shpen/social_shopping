class VotesController < ApplicationController
  before_action :authenticate_user!

  # GET /vote
  def vote
    votable = params[:votable].constantize.find(params[:id])
    if votable.user == current_user
      render nothing: true, status: :unauthorized
      return
    else
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
    end

    respond_to do |format|
      format.js
    end
  end
end