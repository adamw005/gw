Rails.application.routes.draw do
	devise_for :users, :controllers => {:registrations => "registrations"}
  get 'pages/landing'
	get 'pages/landing2'
  get 'projects/show/:id', to: 'projects#show', as: 'projects'
  get 'projects/index'
  get 'projects/new'
	post 'projects/create'
	post 'posts/create'
	post 'comments/create'
	post 'subscriptions/create'
	post 'stripe_infos/create'
	post 'releases/create'
	delete 'subscriptions/destroy/:id', to: 'subscriptions#destroy', as: 'subscriptions_destroy'
	get 'projects/dashboard/:id', to: 'projects#dashboard', as: 'dashboard'
	root to: 'pages#landing2'
	get '/:slug', to: 'projects#show'

	resources :charges

end
