class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

    @questions = @user.get_questions_by_tag(params[:question_tag])
    @questions = sort_by(@questions, params[:question_sort])
    @questions = @questions.paginate(page: params[:question_page], :per_page => 5)

    @answers = @user.get_answers_by_tag(params[:answer_tag])
    @answers = sort_by(@answers, params[:answer_sort])
    @answers = @answers.paginate(page: params[:answer_page], :per_page => 5)

    @question_tags = @user.get_question_tags.map { |tag| tag.name }
    @answer_tags = @user.get_answer_tags.map { |tag| tag.name }

    @params = params.slice(:question_tag, :answer_tag, :question_page, :answer_page, :question_sort, :answer_sort)
  end
end
