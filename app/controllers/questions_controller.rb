class QuestionsController < ApplicationController
  def list
    @questions = Question.paginate(page: params[:page])
  end

  def show
    @question = Question.find(params[:id])
  end
end
