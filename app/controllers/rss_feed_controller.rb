class RssFeedsController < ApplicationController

	def new
    @rss_feed = RssFeed.new
  end

  def create
    @rss_feed = RssFeed.new rss_feed_params
    if @rss_feed.save
      # redirect_to projects_path(@rss_feed.project_id)
    else
      render :action => 'new'
    end
  end

  def show
    @rss_feed = RssFeed.find(params[:hashid])
    # @rss_urls = RssS3.where(project_id: @rss_feed.subscription.project_id)
		@rss_urls = @rss_feed.subscription.project.posts.rss_s3s
		respond_to do |format|
			format.rss {render :layout => false}
		end
  end

	private

	def rss_feed_params
		params.require(:rss_feed).permit(:subscription_id)
	end

end
