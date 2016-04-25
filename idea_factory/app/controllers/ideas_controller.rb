class IdeasController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  before_action :find_idea, only: [:edit, :update, :destroy, :show]

  before_action :authorize_idea, only: [:edit, :update, :destroy]

  def new
    @idea = Idea.new
  end

  def create
    @idea       = Idea.new(idea_params)
    @idea.user  = current_user
    if @idea.save
      redirect_to idea_path(@idea), notice: "Idea created!"
    else
      flash.now[:alert] = "Idea didn't save!"
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def index
    @ideas = Idea.all
  end

  def edit
  end

  def update
    if @idea.update idea_params
      redirect_to idea_path(@idea), notice: "Idea updated!"
    else
      flah.now[:alert] = "Idea not updated!"
      render :edit
    end
  end

  def destroy
    @idea.destroy
    redirect_to ideas_path, notice: "Idea deleted!"
  end

  private

  def authorize_idea
    redirect_to root_path unless can? :crud, @idea
  end

  def find_idea
    @idea = Idea.find params[:id]
  end

  def idea_params
    params.require(:idea).permit([:title, :body])
  end
end
