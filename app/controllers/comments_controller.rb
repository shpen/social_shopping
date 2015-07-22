class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:new, :create]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :check_user_ownership, only: [:edit, :update, :destroy]

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # POST /comments
  def create
    @comment = current_user.comments.build(content: params[:comment][:content], commentable: @commentable)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to redirect_url(@commentable), flash: { success: 'Comment was successfully created.' } }
        format.js
      else
        format.html { render :new }
        format.js { render "shared/error.js", locals: { message: @comment.errors.full_messages.join("\n") } }
      end
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
    # Make sure type is commentable
    def set_commentable
      type = params[:comment][:commentable_type]
      if type == 'Question' || type == 'Answer'
        @commentable = type.constantize.find(params[:comment][:commentable_id])
      else
        redirect_to(request.referrer || root_url, flash: { danger: "You cannot comment on a #{type}" })
      end
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Make sure user taking action is the owner
    def check_user_ownership
      if @comment.user != current_user
        redirect_to(request.referrer || root_url, flash: { danger: 'You do not have permission to do that.' })
      end
    end

    def redirect_url(commentable)
      if commentable.is_a? Question
        question_url(commentable)
      else
        question_url(commentable.question)
      end
    end
end