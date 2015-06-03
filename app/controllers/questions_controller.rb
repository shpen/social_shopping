class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy, :up_vote, :down_vote]
  before_action :check_user_ownership, only: [:edit, :update, :destroy]
  before_action :set_tags, only: :index

  # GET /questions
  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all
    end

    if params[:friends] == 'true'
      @questions = @questions.where(user: current_user.friends)
    end

    @questions = sort_by(@questions, params[:sort])
    @questions = @questions.paginate(page: params[:page], :per_page => 10)

    @params = params.slice(:sort, :tag, :page, :friends)
  end

  # GET /questions/1
  def show
    if params[:success]
      flash.now[:success] = "Successfully shared to Facebook"
    end
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # POST /questions
  def create
    @question = current_user.questions.build(question_params)
    @question.form_saved = true

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
    @question.form_saved = true

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

  # PUT /questions/1/up_vote
  def up_vote
    if current_user.up_votes @question
      redirect_to request.referrer || root_url
    else
      redirect_to request.referrer || root_url, flash: { danger: 'Unable to submit vote.' }
    end
  end

  # PUT /questions/1/down_vote
  def down_vote
    if current_user.down_votes @question
      redirect_to request.referrer || root_url
    else
      redirect_to request.referrer || root_url, flash: { danger: 'Unable to submit vote.' }
    end
  end

  private
    def set_question
      @question = Question.find(params[:id])
      if @question.nil?
        redirect_to request.referrer || root_url, flash: { danger: 'Unable to find question.' }
      end
    end

    def set_tags
      if params[:friends] == 'true'
        @tags = Question.get_tags_from_users(current_user.friends)
      else
        @tags = Question.all_tags
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :description, :tag_list)
    end

    # Make sure user taking action is the owner
    def check_user_ownership
      if @question.user != current_user
        redirect_to(request.referrer || root_url, flash: { danger: 'You do not have permission to do that.' })
      end
    end
end
