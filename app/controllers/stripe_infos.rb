class StripeInfosController < ApplicationController
	def new
		StripeInfo.new
	end

	def create
	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )
		@stripe_info = StripeInfo.new customer_id: customer.id
		@stripe_info.save
		redirect_to :back
		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_charge_path
	end

end




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
