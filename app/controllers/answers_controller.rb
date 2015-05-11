class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy, :up_vote, :down_vote]
  before_action :set_question#, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :check_ids, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :up_vote, :down_vote]
  before_action :check_user_ownership, only: [:edit, :update, :destroy]

  # GET /questions/1/answers/1
  def show
    render 'questions/show'
  end

  # GET /questions/1/answers/new
  def new
    if current_user == @question.user
      redirect_to @question, flash: { danger: 'You cannot answer your own question' }
    end
    
    @answer = Answer.new
  end

  # GET /questions/1/answers/1/edit
  def edit
  end

  # POST /questions/1/answers
  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to question_answer_url(@question, @answer), flash: { success: 'Answer was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1/answers/1
  def update
    if @answer.update(answer_params)
      redirect_to question_answer_url(@answer.question, @answer), flash: { success: 'Answer was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /questions/1/answers/1
  def destroy
    @answer.destroy
    redirect_to @question, flash: { success: 'Answer was successfully destroyed.' }
  end

  # PUT /questions/1/answers/1/up_vote
  def up_vote
    current_user.up_votes @answer
    redirect_to @question
  end

  # PUT /questions/1/answers/1/down_vote
  def down_vote
    current_user.down_votes @answer
    redirect_to @question
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_question
      @question = Question.find(params[:question_id])
    end

    # Make sure params ids line up properly
    def check_ids
      if @answer.question != @question
        raise ActionController::RoutingError.new("Answer id and Question id do not match")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content, :link)
    end

    # Make sure user taking action is the owner
    def check_user_ownership
      @answer = current_user.answers.find_by(id: params[:id])
      if @answer.nil?
        redirect_to(request.referrer || root_url, flash: { danger: 'You do not have permission to do that.' })
      end
    end
end
