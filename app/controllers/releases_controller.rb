class ReleasesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

  def show
		# @release = Release.find(params[:id])
		# @post = @release.posts.build
  end

  def index
		# @releases = Release.all.order(created_at: :desc)
  end

	def new
    @release = Release.new
  end

  def create
		@project = Project.find(release_params[:project_id])
		unless @project.releases.where(created_at: Time.now.beginning_of_day.utc..Time.now.end_of_day.utc)
	    @release = Release.new release_params
	    if @release.save
	      redirect_to :back
	    else
	      render :action => 'new'
	    end
		end
		redirect_to :back
  end

	private

	def release_params
		params.permit(:project_id)
	end

end
