class UsersController < ApplicationController
  def list
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    @questions = @user.questions.paginate(page: params[:page])
  end
end
