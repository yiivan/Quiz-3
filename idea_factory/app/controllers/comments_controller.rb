class CommentsController < ApplicationController

  before_action :authenticate_user!

  def create
    @idea = Idea.find params[:idea_id]
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.idea = @idea
    @comment.user = current_user
    if @comment.save
      redirect_to idea_path(@idea), notice: "Thank you for your comment."
    else
      flash.now[:alert] = "Invalid comment."
      render "ideas/show"
    end
  end

  def destroy
    idea = Idea.find params[:idea_id]
    comment = idea.comments.find params[:id]
    comment.destroy
    redirect_to idea_path(idea), notice: "Comment deleted!"
  end

end
