class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

	def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    if @post.save
      redirect_to projects_path(@post.project_id, anchor: "posts")
    else
      render :action => 'new'
    end
  end

	private

	def post_params
		params.require(:post).permit(:title, :body, :release, :project_id)
	end

end
