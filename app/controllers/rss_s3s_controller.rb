class RssS3sController < ApplicationController

	def new
    @rss_s3 = rss_s3.new
  end

  def create
    @rss_s3 = rss_s3.new rss_s3_params
    if @rss_s3.save
      redirect_to projects_path(@rss_s3.project_id, anchor: "RssS3s")
    else
      render :action => 'new'
    end
  end

	private

	def rss_s3_params
		params.require(:rss_s3).permit(:file)
	end

end
