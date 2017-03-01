class CommentsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

	def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new comment_params
    if @comment.save
      redirect_to projects_path(@comment.project_id, anchor: "comments")
    else
      render :action => 'new'
    end
  end

	private

	def comment_params
		params.require(:comment).permit(:body, :user_id, :project_id)
	end

end
