class RssS3sController < ApplicationController

	def new
    @rss_s3 = RssS3.new
  end

  def create
    @rss_s3 = RssS3.new rss_s3_params
    if @rss_s3.save
      redirect_to projects_path(@rss_s3.project_id)
    else
      render :action => 'new'
    end
  end

  def show
    @rss_s3 = RssS3.find_by(hashid: params[:hashid])
    redirect_to @rss_s3.file.url
  end

	private

	def rss_s3_params
		params.require(:rss_s3).permit(:file, :project_id)
	end

end
