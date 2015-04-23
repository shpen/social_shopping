class UsersController < ApplicationController
  def list
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.paginate(page: params[:page])
  end
end
