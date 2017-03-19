Rails.application.routes.draw do
	devise_for :users, :controllers => {:registrations => "registrations"}
  get 'pages/landing'
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
	get 'projects/dashboard'
	root to: 'pages#landing'
	resources :charges

end
