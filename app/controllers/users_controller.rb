class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.paginate(page: params[:question_page])
    @answers = @user.answers.paginate(page: params[:answer_page])
  end
end
