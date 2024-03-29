class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question#, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_ids, only: [:edit, :update, :destroy]

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_user_ownership, only: [:edit, :update, :destroy]

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

    @show = true

    respond_to do |format|
      if @answer.save
        format.html { redirect_to question_url(@answer.question, answer: @answer), flash: { success: 'Answer was successfully created.' } }
        format.js
      else
        format.html { render :new }
        format.js { render "shared/error.js", locals: { message: @answer.errors.full_messages.join("\n") } }
      end
    end
  end

  # PATCH/PUT /questions/1/answers/1
  def update
    @show = true

    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to question_url(@answer.question, answer: @answer), flash: { success: 'Answer was successfully updated.' } }
        format.js
      else
        format.html { render :edit }
        format.js { render "shared/error.js", locals: { message: @answer.errors.full_messages.join("\n") } }
      end
    end
  end

  # DELETE /questions/1/answers/1
  def destroy
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to @question, flash: { success: 'Answer was successfully destroyed.' } }
      format.js
    end
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
      params.require(:answer).permit(:content)
    end

    # Make sure user taking action is the owner
    def check_user_ownership
      @answer = current_user.answers.find_by(id: params[:id])
      if @answer.nil?
        redirect_to(request.referrer || root_url, flash: { danger: 'You do not have permission to do that.' })
      end
    end
end
