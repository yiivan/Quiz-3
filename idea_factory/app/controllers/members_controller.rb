class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_create, only: :create

  def create
    member          = Member.new
    member.user     = current_user
    member.idea     = idea
    if member.save
      redirect_to ideas_path, notice: "Joined!"
    else
      redirect_to ideas_path, alert: "You've already joined!"
    end
  end

  private

  def authorize_create
    redirect_to ideas_path, notice: "Can't join!" unless can? :join, idea
  end


  def idea
    @idea ||= Idea.find params[:idea_id]
  end

  def member
    @member ||= Member.find params[:id]
  end
end
