class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_create, only: :create
  # before_action :authorize_destroy, only: :destroy

  def create
    like          = Like.new
    like.user     = current_user
    like.idea     = idea
    if like.save
      redirect_to ideas_path, notice: "Liked!"
    else
      redirect_to ideas_path, alert: "You're already liked!"
    end
  end

  # def destroy
  #   like = Like.find params[:id]
  #   like.destroy
  #   redirect_to idea_path(like.idea_id), notice: "Un-liked!"
  # end

  private

  def authorize_create
    redirect_to ideas_path, notice: "Can't like!" unless can? :like, idea
  end

  # def authorize_destroy
  #   redirect_to ideas_path, notice: "Can't remove like!" unless can? :destroy, like
  # end

  def idea
    @idea ||= Idea.find params[:idea_id]
  end

  def like
    @like ||= Like.find params[:id]
  end
end
