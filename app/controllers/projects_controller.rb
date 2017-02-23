class ProjectsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

  def show
		@project = Project.find(params[:id])
		@post = @project.posts.build
  end

  def index
		@projects = Project.all
  end

	def new
    @project = Project.new
		@project.rewards_tiers.build
		@project.goals.build
  end

  def create
    @project = Project.new project_params
    if @project.save
      redirect_to projects_path(@project)
    else
      render :action => 'new'
    end
  end

	private

	def project_params
		params.require(:project).permit(:user_id, :title, :format, :charge_occurrence, :body, :box_image, rewards_tiers_attributes: [:min_amount, :body], goals_attributes: [:amount, :body])
	end

end
