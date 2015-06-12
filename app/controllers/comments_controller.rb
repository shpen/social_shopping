class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]

  # GET /comments/new
  def new
    @commentable = params[:commentable].constantize.find(params[:id])
    @comment = Comment.new
  end

  # POST /comments
  def create
    @commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
    @comment = current_user.comments.build(content: params[:comment][:content], commentable: @commentable)

    if @comment.save
      redirect_to question_url(redirect_url(@commentable)), flash: { success: 'Comment was successfully created.' }
    else
      render :new
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(content: params[:comment][:content])
      redirect_to redirect_url(@comment.commentable), flash: { success: 'Comment was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    commentable = @comment.commentable
    @comment.destroy
    redirect_to redirect_url(commentable), flash: { success: 'Comment was successfully destroyed.' }
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def redirect_url(commentable)
      if commentable.is_a? Question
        question_url(commentable)
      else
        question_url(commentable.question)
      end
    end
end