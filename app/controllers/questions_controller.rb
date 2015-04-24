class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_user_ownership, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions
  def index
    @questions = Question.paginate(page: params[:page])
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # POST /questions
  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, flash: { success: 'Question was successfully created.' }
    else
      render :new
    end
  end

  # GET /questions/1/edit
  def edit
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, flash: { success: 'Question was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, flash: { success: 'Question was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :description)
    end

    # Make sure user taking action is the owner
    def check_user_ownership
      @question = current_user.questions.find_by(id: params[:id])
      if @question.nil?
        redirect_to(request.referrer || root_url, flash: { danger: 'You do not have permission to do that.' })
      end
    end
end
